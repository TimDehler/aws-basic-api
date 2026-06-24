variable "http_api_name" {
  type = string
}

variable "http_api_stage_name" {
  type    = string
  default = "prod"
}

variable "http_stage_throttle_rate_limit" {
  type    = number
  default = 0.00003
}

variable "http_stage_throttle_burst_limit" {
  type    = number
  default = 1
}
