locals{
    users = [
        "andrei",
        "catalin",
        "claudiu",
        "elena",
        "georgian",
        "marius",
        "sanziana",
        "razvan" 

    ]
}


terraform {
  backend "s3" {
    bucket = "sagar-232323"
    key    = "terraform.tfstate"
    region = "us-east-1"
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
  count = 5
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"

  tags = {
    Name = "HelloWorld-${count.index}"
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

resource "aws_iam_group" "attendees" {
  name = "attendees"
  path = "/users/"
}


resource "aws_iam_user" "attendees" {
  count = 8 
  name = local.users[count.index]
  path = "/users/"
}


