resource "azurerm_resource_group" "dev" {
  name     = "${var.dev_cluster.prefix}-k8s-resources"
  location = var.dev_cluster.location
}

resource "azurerm_kubernetes_cluster" "dev" {
  name                = "${var.dev_cluster.prefix}-k8s"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
  dns_prefix          = "${var.dev_cluster.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "dev_extra_1" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.dev.id
  vm_size               = "Standard_A2_v2"
  node_count            = 1
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = 1
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
}
