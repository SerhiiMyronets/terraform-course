resource "local_file" "rendered_config" {
  content = templatefile("hosts_ansible.tpl", {
    instance_ip   = aws_instance.entity.public_ip
    key_address   = local.aws_key.address
    key_file_name = local.aws_key.file_name
  })
  filename = "../ansible/hosts"
}
