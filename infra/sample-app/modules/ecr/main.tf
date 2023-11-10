resource "aws_ecrpublic_repository" "sample-app" {
  repository_name = "sample-app"

  catalog_data {
    architectures     = ["ARM 64"]
    operating_systems = ["Linux"]
  }
}
