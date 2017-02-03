AWS Infrastructure
===================

The purpose of this codebase is to build AWS Infrastructure
with Terraform and possibly Ansible for configuration and
orchestration.

Tools:
------

1.   Terraform - to easily provision AWS resources.
2.   Ansible   - to orchestrate and configure different services if needed?
3.   Ruby      - wrapper script in Ruby >= v2.4.0

Note: Please avoid or minimise bash scripts.

Rules on writing Terraform code:
--------------------------------

i. Group different resources to form a logical unit/service and make it
modular and independent with each other and inject data using YAML
which can be found in config/<environment>/<site-name>. For i.e.
config/production/management.yaml. 

ii. For each resources that allows tagging, add tags Terraform=true. The
reason for this is so we if want to destroy resources and we happen to
also lost the statefile, we can simply write a loop that would destroy
resources with tag name Terraform=true.

iii. YAML config write as flat as possible. We want to avoid having to
write a complex wrapper code and update this everytime we change our
YAML structure.

Usage:
------

To maintain consistency of the workflow for users within the team,
we have a Ruby wrapper script would basically generate a root.tf.json
from a YAML configuration file for different services in multiple
environments.

```
bundle install
bundle exec ruby ./bin/run.rb
bundle exec ruby ./bin/run.rb terraform <environment> <site-name>
bundle exec ruby ./bin/run.rb terraform production management
```

After a root.tf.json file is generated, this will describe a site's
entire infrastructure. Whenever we want to run plan or apply, we 
always apply this per module. This is so we take advantage of our
modular component/service design rather than applying against all
services in a site.

To update get modules updates:

```
terraform get -update=true
```

If backend statefile is configured, pull the remote statefile
and sync it locally with:

```
terraform remote pull
```

To apply specific service/component:

```
terraform plan -target=module.vpc
terraform apply -target=module.vpc
```

To configure to use S3 backend to store statefile for a new service/
component:

```
make help
make set-backend SITE=management ENVIRONMENT=production MODULE=vpc
```

To disable remote backend config:

```
terraform remote config -pull=false
```

or

```
terraform remote config -disable
```

Above command would soon be replaced with Rakefile or Makefile?

TODO:
-----

i. In wrapper script, add terraform get, sync remote statefile with local 
to prevent corruption of statefile.

ii. Write a test to validate our YAML structure and make sure this is as flat
as possible.

iii. Code version release script.

## Credits

JChan

## License

TODO: License

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request.

