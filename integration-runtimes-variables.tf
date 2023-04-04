variable "integration_runtimes" {
  description = "A list of integration runtimes."
  type = list(object({
    name             = string
    location         = optional(string, null)
    compute_type     = string
    core_count       = number
    description      = optional(string, "")
    time_to_live_min = optional(number, 0)
  }))
  default = []
}

variable "self_hosted_integration_runtimes" {
  description = "A list of self hosted integration runtimes."
  type = list(object({
    name        = string
    description = optional(string, "")
  }))
  default = []
}
