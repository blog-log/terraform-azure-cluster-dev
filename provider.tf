# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.75.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  required_version = ">= 1.0.6"
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "dev-k8s"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "dev-k8s"
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "dev-k8s"
}