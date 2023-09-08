variable "vpc-cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "project" {
    type = string
    default = "autoscaling-project"
}

variable "ami" {
    type = string
    default = "ami-07be51e3c6d5f61d2"
  
}