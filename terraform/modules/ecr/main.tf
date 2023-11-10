resource "aws_ecrpublic_repository" "todo" {
  repository_name = "todo"

  catalog_data {
    architectures     = ["ARM 64"]
    operating_systems = ["Linux"]
  }
}
