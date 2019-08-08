# Module tests

This folder contains a experiment to write a test for creation of a VPC.


## Running automated tests against this module. 

!!! Be-aware this test will create resources in AWS. 

1. Setup AWS credentials.
1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
1. `dep ensure`
1. `go test -v -run TestTerraformAwsPublicVpc`
