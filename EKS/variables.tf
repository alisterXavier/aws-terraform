variable "subnets" {
  type = list(object({
    az = string
    ip = string
  }))
  default = [{
    az = "us-east-1a",
    ip = "10.0.0.0/22"
    },
    {
      az = "us-east-1b",
      ip = "10.0.4.0/22"
  }]
}

variable "pub_subnets" {
  type = list(object({
    az = string
    ip = string
  }))
  default = [
    {
      az = "us-east-1a",
      ip = "10.0.8.0/23"
    },
    {
      az = "us-east-1b",
      ip = "10.0.10.0/23"
  }]
}

variable "cluster_name" {
  type    = string
  default = "terraform-eks-cluster"
}

variable "prometheus-username" {
  type    = string
  default = ""
}
variable "loki-url" {
  type    = string
  default = ""
}
variable "cloud-access-token" {
  type    = string
  default = ""
}
variable "loki-username" {
  type    = string
  default = ""
}
variable "cluster-name" {
  type    = string
  default = ""
}
variable "prometheus-url" {
  type    = string
  default = ""
}
