provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "ayimdar"
  region = "us-west-2"
}