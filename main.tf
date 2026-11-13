terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.0"
    }
  }
}

resource "local_file" "web_infra" {
  filename = "${path.module}/docker-compose.yml"
  content  = <<-EOT
    services:
      web-server:
        image: nginx:alpine
        ports:
          - "8080:80"
        deploy:
          replicas: 3
  EOT
}