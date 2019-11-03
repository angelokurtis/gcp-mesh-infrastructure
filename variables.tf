variable "gcloud_project" {
  default = "fiery-palace-245011"
}

variable gcloud_account {
  default = "matheus.moraes@sensedia.com"
}

variable "gcloud_region" {
  default = "us-central1"
}

variable "cluster_name" {
  default = "mesh-cluster"
}

variable helm_version {
  type = "string"
  default = "2.15.2"
}

variable istio_version {
  type = "string"
  default = "1.3.4"
}

variable istio_namespace {
  type = "string"
  default = "istio-system"
}