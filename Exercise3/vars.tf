# variable declaration

variable region {
    default = "us-west-1"
}

variable zone1 {
    default = "us-west-1a"
}

variable amiID {
  type = map
  default = {
    us-west-2 = ""
    us-east-1 = ""
  }
}