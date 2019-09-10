provider "kubernetes" {
  host = google_container_cluster.gcloud_cluster.endpoint
  token = data.google_client_config.current.access_token
  client_certificate = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.client_certificate)
  client_key = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.gcloud_cluster.master_auth.0.cluster_ca_certificate)
}

resource "kubernetes_service_account" "tiller_account" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_role" {
  metadata {
    name = "tiller-role"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.tiller_account.metadata[0].name
    namespace = "kube-system"
  }

  depends_on = [
    "kubernetes_service_account.tiller_account"
  ]
}

resource "kubernetes_deployment" "tiller_deployment" {
  metadata {
    name = "tiller-deploy"
    labels = {
      app = "helm"
      name = "tiller"
    }
    namespace = "kube-system"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helm"
        name = "tiller"
      }
    }

    template {
      metadata {
        labels = {
          app = "helm"
          name = "tiller"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.tiller_account.metadata[0].name
        automount_service_account_token = true
        container {
          image = "gcr.io/kubernetes-helm/tiller:v${var.helm_version}"
          image_pull_policy = "IfNotPresent"
          name = "tiller"
          env {
            name = "TILLER_NAMESPACE"
            value = "kube-system"
          }
          env {
            name = "TILLER_HISTORY_MAX"
            value = "0"
          }
          liveness_probe {
            http_get {
              path = "/liveness"
              port = 44135
            }
            initial_delay_seconds = 1
            timeout_seconds = 1
          }
          readiness_probe {
            http_get {
              path = "/readiness"
              port = 44135
            }
            initial_delay_seconds = 1
            timeout_seconds = 1
          }
          port {
            name = "tiller"
            container_port = 44134
          }
          port {
            name = "http"
            container_port = 44135
          }
        }
      }
    }
  }

  depends_on = [
    "kubernetes_cluster_role_binding.tiller_role"
  ]
}

resource "kubernetes_service" "tiller_service" {
  metadata {
    name = "tiller-deploy"
    namespace = "kube-system"
    labels = {
      app = "helm"
      name = "tiller"
    }
  }
  spec {
    selector = {
      app = "helm"
      name = "tiller"
    }
    session_affinity = "ClientIP"
    port {
      name = "tiller"
      port = 44134
      target_port = "tiller"
    }
    type = "ClusterIP"
  }

  depends_on = [
    "kubernetes_deployment.tiller_deployment"
  ]
}

data "google_client_config" "current" {}