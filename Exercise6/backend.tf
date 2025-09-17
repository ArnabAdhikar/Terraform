terraform {
  backend "s3" {
    bucket = "terraform713205"
    key = "terraform/backend"
    region = "eu-north-1"
  }
}