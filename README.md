Terraform code to spin up Ubuntu 22.04 VMs in Linode and Digital Ocean.


```sh
terraform init
```

```sh
terraform providers lock \
  -platform=linux_amd64 \
  -platform=linux_arm64
```
