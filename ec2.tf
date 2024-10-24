terraform {
  backend "s3" {
    bucket = "sagar-232323"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-lock-table"
  }
}



resource "aws_s3_bucket" "example" {
  bucket = "noble-prog-test-bucket-232323"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  count = 4
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld-${count.index}"
    Team = "Alpha"
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

provider "aws" {
  region = "us-east-1"
}

