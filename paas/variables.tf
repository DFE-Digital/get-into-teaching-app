# These settings are for the sandbox and should mainly be overriden by TF_VARS 
# or set with environment variables TF_VAR_xxxx

variable user {
    default = "get-into-teaching-tech@digital.education.gov.uk"
}

variable api_url {
     default = "https://api.london.cloud.service.gov.uk"
}

variable password {}


variable "application_stopped" {
   default = false
}

variable "paas_space" {
   default = "sandbox"
}

variable "paas_org_name" {
   default = "dfe-teacher-services"
}

variable "logging" {
  default = 1
}

variable "additional_routes" {
  default = 1
}

variable "paas_additional_route_name" {
   default = ""
}

variable "paas_app_route_name" {}

variable "paas_logging_name" {
   default = "logit-ssl-drain"
}

variable "paas_app_application_name" {
   default = "dfe-teacher-services-app"
}

variable "paas_app_docker_image" {
   default = "dfedigital/get-into-teaching-frontend:latest"
}

variable "strategy" {
   default = "blue-green"
}

variable "HTTPAUTH_PASSWORD" {}
variable "HTTPAUTH_USERNAME" {}
variable "RAILS_ENV" {}
variable "RAILS_MASTER_KEY" {}
