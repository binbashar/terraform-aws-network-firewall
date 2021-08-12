# Terraform Module Tests: Terratests

## Overview

Terratest is a Go library that makes it easier to write automated tests for your
 infrastructure code.
It provides a variety of helper functions and patterns for common infrastructure
 testing tasks, including:

- Testing Terraform code
- Working with AWS APIs
- And much more

Official **terratest** [documentation available on GitHub project repo](https://github.com/gruntwork-io/terratest).
Ref Article [available on Medium maintainers blog](https://blog.gruntwork.io/open-sourcing-terratest-a-swiss-army-knife-for-testing-infrastructure-code-5d883336fcd5).

### Install requirements

Terratest uses the Go testing framework. To use terratest, you need to install:

- [Go](https://golang.org/) (requires version >=1.10)
- [dep](https://github.com/golang/dep) (requires version >=0.5.1)

## Files Organization

* Terraform files are located at the root of this directory.
* Tests can be found under tests/ directory.

## Testing

### Key Points

* We use `terratest` for testing this module.
* Keep in mind that `terratest` is not a binary but a Go library with helpers
 that make it easier to work with Terraform and other tools.
* Test files use `_test` suffix.
 E.g.: `create_file_with_default_values_test.go`
* Test classes use `Test` prefix.
 E.g.: `func TestCreateFileWithDefaultValues(t *testing.T) {`
* Our tests make use of a fixture/ dir that resembles how the module will be used.

### Set Up

#### Dokerized Makefile

```
$ make
Available Commands:
...
 - terratest-dep-init dep is a dependency management tool for Go. (https://github.com/golang/dep)
 - terratest-go-test  Run E2E terratests
...
```

1. `make terratest-dep-init`

```
$ make terratest-dep-init
docker run --rm -v /home/delivery/Binbash/repos/BB-Leverage/terraform/terraform-aws-ec2-basic-layout:"/go/src/project/":rw -v ~/.ssh:/root/.ssh -v ~/.gitconfig:/etc/gitconfig --entrypoint=dep -it binbash/terraform-resources:0.11.14 init
  Locking in master (da137c7) for transitive dep golang.org/x/net
  Using ^1.3.0 as constraint for direct dep github.com/stretchr/testify
  Locking in v1.3.0 (ffdc059) for direct dep github.com/stretchr/testify
  Locking in v1.0.0 (792786c) for transitive dep github.com/pmezard/go-difflib
  Using ^0.17.5 as constraint for direct dep github.com/gruntwork-io/terratest
  Locking in v0.17.5 (03959c9) for direct dep github.com/gruntwork-io/terratest
  Locking in v1.1.1 (8991bc2) for transitive dep github.com/davecgh/go-spew
  Locking in master (4def268) for transitive dep golang.org/x/crypto
  Locking in master (04f50cd) for transitive dep golang.org/x/sys
docker run --rm -v /home/delivery/Binbash/repos/BB-Leverage/terraform/terraform-aws-ec2-basic-layout:"/go/src/project/":rw -v ~/.ssh:/root/.ssh -v ~/.gitconfig:/etc/gitconfig --entrypoint=dep -it binbash/terraform-resources:0.11.14 ensure
sudo chown -R delivery:delivery .
cp -r ./vendor ./tests/ && rm -rf ./vendor
cp -r ./Gopkg* ./tests/ && rm -rf ./Gopkg*
```

2. `terratest-go-test`

```
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158: Destroy complete! Resources: 23 destroyed.
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158:
...
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158:
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158: Warning: output "aws_s3_bucket_ssl_certificates_bucket_domain_name": must use splat syntax to access aws_s3_bucket.ssl_certificates_bucket attribute "bucket_domain_name", because it has "count" set; use aws_s3_bucket.ssl_certificates_bucket.*.bucket_domain_name to obtain a list of the attributes across all instances
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158:
TestInstanceJenkinsVault 2019-07-08T02:42:42Z command.go:158:
PASS
ok      project/tests   227.167s
sudo chown -R delivery:delivery .

```

#### Local installed deps execution

* Make sure this module is within the **GOPATH directory**.
    * Default GOPATH is usually set to `$HOME/go` but you can override that permanently or temporarily.
    * For instance, you could place all your modules under `/home/john.doe/project_name/tf-modules/src/`
    * Then you would use `export GOPATH=/home/john.doe/project_name/tf-modules/`
    * Or you could simply place all your modules under `$HOME/go/src/`
* Go to the `tests/` dir and run `dep ensure` to resolve all dependencies.
    * This should create a `vendor/` dir under `tests/` dir and also a `pkg/` dir under the GOPATH dir.
* Now you can run `go test`

### Tests Result: Passing

```
TestAwsEc2BasicLayout 2019-11-28T15:01:04Z command.go:158: module.terraform-aws-basic-layout.aws_security_group.main: Destroying... [id=sg-0f6b79c3a9e030a17]
TestAwsEc2BasicLayout 2019-11-28T15:01:04Z command.go:158: aws_iam_instance_profile.basic_instance: Destroying... [id=basic-instance-profile]
TestAwsEc2BasicLayout 2019-11-28T15:01:06Z command.go:158: module.terraform-aws-basic-layout.aws_security_group.main: Destruction complete after 1s
TestAwsEc2BasicLayout 2019-11-28T15:01:06Z command.go:158: aws_iam_instance_profile.basic_instance: Destruction complete after 2s
TestAwsEc2BasicLayout 2019-11-28T15:01:06Z command.go:158: aws_iam_role.basic_instance_assume_role: Destroying... [id=basic-instance-role]
TestAwsEc2BasicLayout 2019-11-28T15:01:08Z command.go:158: aws_iam_role.basic_instance_assume_role: Destruction complete after 1s
TestAwsEc2BasicLayout 2019-11-28T15:01:08Z command.go:158:
TestAwsEc2BasicLayout 2019-11-28T15:01:08Z command.go:158: Destroy complete! Resources: 12 destroyed.
PASS
ok      project/tests   248.921s
sudo chown -R delivery:delivery .

```
