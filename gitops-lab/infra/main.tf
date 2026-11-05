terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

resource "local_file" "service" {
  filename        = "${path.module}/runtime/service.json"
  content         = file("${path.module}/desired.json")
  file_permission = "0644"
}
