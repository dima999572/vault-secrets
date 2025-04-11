resource "random_string" "master_key" {
  length  = 32
  special = true
}

resource "random_string" "join_key" {
  length  = 32
  special = true
}
