package test

import (
	"fmt"

	"terratest/modules/terraform"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsVpcPublic(t *testing.T) {
	t.Parallel()

	// Set name for the test environment.
	environment := fmt.Sprintf("terratest-aws-vpc-%s", "qgEDYE-vpc")

	// Set an AWS region
	awsRegion := "eu-central-1"

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/vpc-public",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"environment": environment,
			"aws_region":  awsRegion,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// his will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Plan(t, terraformOptions)

	// Find vpc-id in the terraform output
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")

	// Create AWS session
	awsSession, err := session.NewSession(&aws.Config{
		Region: aws.String(awsRegion)},
	)
	svc := ec2.New(awsSession)

	// Find the created VPC based on the vpc-id
	vpcOutput, err := svc.DescribeVpcs(&ec2.DescribeVpcsInput{
		VpcIds: aws.StringSlice([]string{vpcID}),
	})

	// Verify results only contains one VPC
	assert.Equal(t, 1, len(vpcOutput.Vpcs))
	tags := vpcOutput.Vpcs[0].Tags
	var nameTag ec2.Tag

	for _, v := range tags {
		if *v.Key == "Name" {
			fmt.Println("Value: ", *v.Value)
			nameTag = *v
		}
	}

	// Verify environment tag
	assert.Equal(t, environment, *nameTag.Value)

	// Check number of subnets, should be equal to AZ.
	subnets, err := svc.DescribeSubnets(&ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{&ec2.Filter{
			Name:   aws.String("vpc-id"),
			Values: aws.StringSlice([]string{vpcID}),
		}},
	})
	az, err := svc.DescribeAvailabilityZones(&ec2.DescribeAvailabilityZonesInput{})
	assert.Equal(t, len(az.AvailabilityZones), len(subnets.Subnets))

	if err != nil {
		fmt.Println("Something wrong :( - TODO handle errors", err)
		return
	}

}
