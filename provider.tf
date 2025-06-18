provider "aws" {
  region = "us-west-2"      
    
}
provider "helm" {
    kubernetes {
      host =  "~/.kube/config"
    }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
