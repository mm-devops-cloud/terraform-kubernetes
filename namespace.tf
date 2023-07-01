resource "kubernetes_namespace" "MM" {
  metadata {
    name = "mm-terraform"
    labels ={ ENV = "Staging" }
  }
}