resource "aws_key_pair" "davis_key" {
  key_name   = "RKE2-test"
  public_key = file("~/.ssh/id_rsa.pub")
}
