resource "kubernetes_deployment" "terraform-deployment" {
  metadata {
    # name = "terraform-nginx"  # we can put specific name or we can use generate name like this example and we can do that even for pod
    generate_name = "terraform-nginx-"
    labels = {
      ENV = "Staging" ,
      app = "terra-nginx"
    }
    namespace = kubernetes_namespace.MM.id  # here i set the namespace this deployment will run on it
    
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "terra-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "terra-nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "terraform-nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
            # here we config health check to application we tell delay for 15 seconds before start send to check 
            # and check each 5 seconds ( we can check TCP port , http ,run command to check)
          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 15
            period_seconds        = 5
          }
        }

        restart_policy = "Always" # by default always but i can change to "Always, OnFailure, Never."
      }
    }
  }
}