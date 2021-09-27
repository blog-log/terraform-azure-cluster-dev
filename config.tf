data "kubectl_path_documents" "config_manifests" {
  pattern = "./files/config/*.yaml"
}

resource "kubectl_manifest" "config_manifests" {
  count     = length(data.kubectl_path_documents.config_manifests.documents)
  yaml_body = element(data.kubectl_path_documents.config_manifests.documents, count.index)
}