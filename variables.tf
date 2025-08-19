variable "env" {
  default = "Dev"
  type    = string

}
variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "instance_ami" {
  default = "ami-0144277607031eca2"
  type = string
}
