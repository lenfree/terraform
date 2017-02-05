#!/bin/bash

# ES 5.x requires Java v8

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A
touch /etc/apt/sources.list.d/openjdk.list
echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" | \
  sudo tee -a /etc/apt/sources.list.d/openjdk.list 
echo "deb-src http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" | \
  sudo tee -a /etc/apt/sources.list.d/openjdk.list
sudo apt-get clean
sudo apt-get update
sudo apt-get install --force-yes -y openjdk-8-jre openjdk-8-jdk openjdk-8-jdk-headless libxt-dev

sudo update-ca-certificates -f

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | \
  sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

sudo apt-get install apt-transport-https

sudo apt-get -y update && sudo apt-get install -y logstash

sudo update-ca-certificates -f

sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-s3
sudo /usr/share/logstash/bin/logstash-plugin install logstash-codec-cloudtrail
sudo /usr/share/logstash/bin/logstash-plugin install logstash-output-amazon_es

cat << 'END_OF_FILE' > /home/ubuntu/logstash.conf
input {
    s3 {
      bucket => "trail-management-pr"
      region => "us-east-1"
      type => "s3"
      add_field => { source => gzfiles }
      codec => cloudtrail {}
    }
}
output {
  amazon_es {
        hosts => ["\"${elasticsearch_host}\""]
        region => "us-east-1"
        index => "trail-logs-%{+YYYY.MM.dd}"
    }
}
END_OF_FILE

sudo chown ubuntu:ubuntu /home/ubuntu/logstash.conf

# Start logstash with default workers and other options.
# For production, best to increase workers.
# More info on these options:
# https://www.elastic.co/guide/en/logstash/current/command-line-flags.html
# https://www.elastic.co/guide/en/logstash/current/performance-troubleshooting.html
# https://www.elastic.co/blog/a-history-of-logstash-output-workers
sudo /usr/share/logstash/bin/logstash -f /home/ubuntu/logstash.conf