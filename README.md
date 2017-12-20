# Previder Terraform Examples

This directory contains a set of examples of using Previder IaaS services with
Terraform. The examples each have their own README containing more details
on what the example does.

Before you run any example, make sure that you have our [terraform-provider-previder](https://github.com/previder/terraform-provider-previder) plugin installed in your GOPATH.

To run any example, clone this repository and run `terraform apply` within
the example's own directory.

For example:

```
$ git clone https://github.com/previder/previder-terraform-examples
$ cd previder-terraform-examples/windows-2016-ansible-iis
$ terraform apply
...
```
