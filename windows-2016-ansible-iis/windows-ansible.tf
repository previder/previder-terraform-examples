variable "previder_token" { default = "" }

variable "windows_name" { default = "windows-test1" }

provider "previder" {
	token = "${var.previder_token}"
}

output "public_ip" {
	value = "${previder_virtualmachine.winrm.network_interface.0.ipv4_address.0}"
}

resource "previder_virtualmachine" "winrm" {
    name = "${var.windows_name}"
    cpucores = 2
    memory = 4096
    template = "Windows 2016"
    cluster = "Express"
    disk = [
        { size = 102400 }
    ]
    network_interface = [
        { network = "Public WAN" }
    ]
   user_data = <<EOF
#sysprep-properties
command.1=netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
command.2=netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow
command.3=winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
EOF

   provisioning_type = "SYSPREP"
   connection {
        user = "Administrator"
        type = "winrm"
        password = "${previder_virtualmachine.winrm.initial_password}"
        timeout = "10m"
    }
}

resource "null_resource" "exec-remote-file" {
    depends_on = ["previder_virtualmachine.winrm"]
    provisioner "local-exec" {
        command = <<EOT
cat > windows.yml <<EOF
[windows]
${previder_virtualmachine.winrm.network_interface.0.ipv4_address.0}
EOF
cat > group_vars/windows.yml <<EOF
ansible_user: Administrator
ansible_password: ${previder_virtualmachine.winrm.initial_password}
ansible_port: 5985
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
EOF
ansible-playbook -i windows.yml -T 900 ansible-enable-iis.yml
EOT
    }
}
