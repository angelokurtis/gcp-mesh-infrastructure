variable "gcloud_project" {
  default = "mesh-project"
}

variable gcloud_account {
  default = "kurtis.angelo@gmail.com"
}

variable "gcloud_region" {
  default = "us-central1"
}

variable "cluster_name" {
  default = "mesh-cluster"
}

variable helm_version {
  type = "string"
  default = "2.14.3"
}

variable istio_version {
  type = "string"
  default = "1.2.5"
}

variable istio_namespace {
  type = "string"
  default = "istio-system"
}