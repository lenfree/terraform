#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'installing additional software'
for i in {1..5}
do  
       # Enable below to allow Docker to use the aufs storage drivers.
    # apt-get update
    # apt-get install -y --no-install-recommends \
    #  linux-image-extra-$(uname -r) \
    #  linux-image-extra-virtual
    curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
    apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
    sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
    apt-get update
    apt-get -y install docker-engine unzip
    curl -o consul.zip \
      https://releases.hashicorp.com/consul/0.7.4/consul_0.7.4_linux_amd64.zip?_ga=1.163455103.2104290826.1486944921
    unzip consul.zip
    apt-get install -y awscli && break || sleep 120
done

################################################################################
# Running Consul
################################################################################
# get current instance ip
INSTANCE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# get list of available Consul servers; based on Name (value) tag!
IP_LIST=$(aws ec2 describe-instances --region us-east-1 \
--filters 'Name=tag:Name,Values=${consul_cluster_name}' \
'Name=instance-state-name,Values=running' \
--query "Reservations[*].Instances[*].PrivateIpAddress" \
--output=text)

# remove the current instance ip from the list of available servers
IP_LIST="$${IP_LIST/$$INSTANCE_IP/}"

# remove duplicated spaces, \r\n and replace space by ','
IP_LIST=$(echo $$IP_LIST | tr -s " " | tr -d '\r\n' | tr -s ' ' ',')

# create join string
for i in $(echo $IP_LIST | sed "s/,/ /g")
do
    JOIN_STRING+="-retry-join $i "
done

# - run Consul
docker run -d --net=host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
--name consul-server consul:latest \
agent -server -bind=$INSTANCE_IP $JOIN_STRING \
-bootstrap-expect=${consul_cluster_min_size} -ui -client 0.0.0.0
# ------------------------------------------------------------------------------