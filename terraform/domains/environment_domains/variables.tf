variable "hosted_zone" {
  type    = map(any)
  default = {}
}

variable "rate_limit" {
  type = list(object({
    agent        = optional(string)
    priority     = optional(number)
    duration     = optional(number)
    limit        = optional(number)
    selector     = optional(string)
    operator     = optional(string)
    match_values = optional(string)
  }))
  default = null
}
