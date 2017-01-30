/* Bug with >= 0.8.0 where provider
not able to interpolate region properly.
Should be fixed in release 0.9

https://github.com/hashicorp/terraform/issues/10722
*/
provider "aws" {
  region = "us-east-1"
}

# Lock version
terraform {
  required_version = "0.8.1"
}
