# Terraform Windows Ansible example

This example will create a Windows virtualmachine and run install.bat.

**On ubuntu:**
- Install python winrm module
```
apt-get install python-winrm
```

- Change directory to windows-2016-winrm-remote-exec
```
cd previder-terraform-examples/windows-2016-winrm-remote-exec
```

- Add the API token provided by Previder at previder_token
```
variable "previder_token" { default = "<insert API key here>" }
```

- Run terraform apply
```
$ terraform apply
...
```