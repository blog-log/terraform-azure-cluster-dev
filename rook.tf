resource "kubernetes_namespace" "rook_ceph" {
  metadata {
    name = "rook-ceph"
  }

  depends_on = [
    azurerm_kubernetes_cluster.dev
  ]
}

data "kubectl_path_documents" "rook_init_manifests" {
  pattern = "./files/rook/init/*.yaml"
}

resource "kubectl_manifest" "rook_init_manifests" {
  count     = length(data.kubectl_path_documents.rook_init_manifests.documents)
  yaml_body = element(data.kubectl_path_documents.rook_init_manifests.documents, count.index)

  depends_on = [
    kubernetes_namespace.rook_ceph
  ]
}

resource "helm_release" "rook_ceph" {
  name = "rook-ceph"

  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph"

  version = "v1.7.5"

  namespace = kubernetes_namespace.rook_ceph.metadata[0].name

  values = [
    "${file("./helm/rook/ceph-operator.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.rook_ceph
  ]
}

data "kubectl_path_documents" "rook_ceph_manifests" {
  pattern = "./files/rook/ceph/*.yaml"
}

resource "kubectl_manifest" "rook_ceph_manifests" {
  count     = length(data.kubectl_path_documents.rook_ceph_manifests.documents)
  yaml_body = element(data.kubectl_path_documents.rook_ceph_manifests.documents, count.index)

  override_namespace = kubernetes_namespace.rook_ceph.metadata[0].name

  depends_on = [
    helm_release.rook_ceph,
    kubernetes_namespace.rook_ceph
  ]
}