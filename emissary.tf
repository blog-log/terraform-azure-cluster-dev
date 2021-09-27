resource "kubernetes_namespace" "emissary" {
  metadata {
    name = "emissary"
  }

  depends_on = [
    azurerm_kubernetes_cluster.dev
  ]
}

resource "helm_release" "emissary_ingress" {
  name = "emissary-ingress-controller"

  repository = "https://app.getambassador.io"
  chart      = "emissary-ingress"

  version = "7.1.2-ea"

  devel = true

  namespace = kubernetes_namespace.emissary.metadata[0].name

  depends_on = [
    kubernetes_namespace.emissary
  ]
}

data "kubectl_path_documents" "emissary_manifests" {
  pattern = "./files/emissary/*.yaml"
}

resource "kubectl_manifest" "emissary_manifests" {
  count     = length(data.kubectl_path_documents.emissary_manifests.documents)
  yaml_body = element(data.kubectl_path_documents.emissary_manifests.documents, count.index)

  override_namespace = kubernetes_namespace.emissary.metadata[0].name

  depends_on = [
    helm_release.emissary_ingress,
    kubernetes_namespace.emissary
  ]
}