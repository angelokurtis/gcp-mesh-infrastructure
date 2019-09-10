provider "helm" {
  install_tiller = false

  kubernetes {
    host = google_container_cluster.gcloud_cluster.endpoint
    token = data.google_client_config.current.access_token
    client_certificate = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.client_certificate)
    client_key = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.cluster_ca_certificate)
  }
}

resource "helm_release" "istio_init" {
  name = "istio-init"
  repository = data.helm_repository.istio_repository.url
  chart = "istio-init"
  version = var.istio_version
  namespace = var.istio_namespace

  depends_on = [
    "kubernetes_service.tiller_service"
  ]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    "helm_release.istio_init"
  ]
}

resource "helm_release" "istio" {
  name = "istio"
  repository = data.helm_repository.istio_repository.url
  chart = "istio"
  version = var.istio_version
  namespace = var.istio_namespace

  set {
    name = "grafana.enabled"
    value = "true"
  }

  set {
    name = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name = "kiali.enabled"
    value = "true"
  }

  set {
    name = "kiali.ingress.enabled"
    value = "true"
  }

  depends_on = [
    "null_resource.delay",
  ]
}

data "helm_repository" "istio_repository" {
  name = "istio.io"
  url = "https://storage.googleapis.com/istio-release/releases/${var.istio_version}/charts"
}
