variable "hosted_zone" {
  type = map(any)
}

variable "hosted_zone_without_front_door" {
  type = map(any)
}

variable "deploy_default_records" {
  default = true
}
