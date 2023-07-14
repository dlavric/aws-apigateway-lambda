variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default = {
    "envone"   = "one"
    "envtwo"   = "two"
    "envthree" = "three"
  }
}

variable "create_function" {
  description = "Controls whether Lambda Function resource should be created"
  type        = bool
  default     = true
}
