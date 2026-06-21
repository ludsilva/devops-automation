variable "resource_group_name" {
  description = "Nome do grupo de recursos onde o AKS será provisionado"
}

variable "location" {
  description = "Região onde os recursos serão provisionados"
}

variable "aks_cluster_name" {
  description = "Nome do cluster AKS"
}