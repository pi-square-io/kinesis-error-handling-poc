variable "project_tags" {
  description = "Project tags to be attached to resources"
  type = object({
    PROJECT_NAME = string
    OWNER        = string
    COSTCENTER   = string
  })
}


variable "project_name" {
  type = string
}


variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "db_password" {
  type    = string
  default = "PISQUARE2021"
}

variable "lambda_source_code" {
  type        = string
  description = "Lambda source code path it should be .zip"
  default     = "lambda_source_code.zip"
}