################################################################################
# RDS AZ Replication Module
# Create AWS RDS cluster using terraform with Cross-Region replication
################################################################################

provider "aws" {
  region = "us-east-2"
}

# Provider for Read Replica
provider "aws" {
  region = "us-west-2"
  alias  = "replica"
}

