variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
}
