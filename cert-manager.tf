// cert manager will be installed in same namespace as emissary to allow easier finding of certs
resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  version = "v1.5.3"

  set {
    name  = "installCRDs"
    value = "true"
  }

  namespace = kubernetes_namespace.emissary.metadata[0].name

  depends_on = [
    kubernetes_namespace.emissary
  ]
}

data "kubectl_path_documents" "cert_manager_manifests" {
  pattern = "./files/certmanager/*.yaml"
}

resource "kubectl_manifest" "cert_manager_manifests" {
  count     = length(data.kubectl_path_documents.cert_manager_manifests.documents)
  yaml_body = element(data.kubectl_path_documents.cert_manager_manifests.documents, count.index)

  override_namespace = kubernetes_namespace.emissary.metadata[0].name

  depends_on = [
    helm_release.cert_manager
  ]
}