resource "docker_image" "image_name" {
  name = "nginx:latest"
}


resource "docker_container" "nginx_container" {
  name = "testcontainer"
  image = docker_image.image_name.name
  ports {
    internal = var.internal_port 
    external = var.external_port 
  }
}
