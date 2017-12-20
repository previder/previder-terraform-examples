# Terraform Windows Ansible example

This example will create a Windows virtualmachine and install IIS trough Ansible.

**On ubuntu:**
- Install ansible
```
apt-get install ansible
```
- Install python winrm module
```
apt-get install python-winrm
```

- Change directory to windows-2016-ansible-iis
```
cd previder-terraform-examples/terraform-2016-ansible-iis
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