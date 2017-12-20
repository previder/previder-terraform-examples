variable "previder_token" { default = "" }

variable "vmname" { default = "windows-test" }

provider "previder" {
	token = "${var.previder_token}"
}

resource "previder_virtualmachine" "winrm" {
    name = "${var.vmname}"
    cpucores = 2
    memory = 2048
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
    provisioner "file" {
        source = "./install.bat"
        destination = "C:\\Windows\\Temp\\install.bat"
    }

}

resource "null_resource" "exec-remote-file" {
    depends_on = ["previder_virtualmachine.winrm"]
    connection {
        host = "${previder_virtualmachine.winrm.network_interface.0.ipv4_address.0}"
        user = "Administrator"
        type = "winrm"
        password = "${previder_virtualmachine.winrm.initial_password}"
        timeout = "10m"
    }
    provisioner "remote-exec" {
        inline = [
            "C:\\Windows\\Temp\\install.bat"
        ]
    }

}

