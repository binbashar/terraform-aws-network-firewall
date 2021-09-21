package test

import (
  "fmt"
	"testing"
  "strconv"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Check Network Firewall, stateless & stateful rules
func TestTerraformNetworkFirewall(t *testing.T) {
	t.Parallel()

	expectedStatelessMap := map[string]string{"stateless-group-example-1": "100", }
	expectedStatefulMap := map[string]string{"stateful-group-example-1": "Stateful Inspection for denying access to domains",  "stateful-group-example-2" : "Stateful Inspection for allowing access to domains", "stateful-group-example-3" : "Permits http traffic from source" }
	minNumAzs := 1

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/complete",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
  actualStatelessMap := terraform.OutputMap(t, terraformOptions, "network_firewall_stateless_group")
  actualStatefulMap := terraform.OutputMap(t, terraformOptions, "network_firewall_stateful_group")
  //actualExample := terraform.Output(t, terraformOptions, "num_network_firewall_azs")
  nfwAzs,err  := strconv.Atoi(terraform.Output(t, terraformOptions, "num_network_firewall_azs"))

  fmt.Println(">>>>>> stateless:", actualStatelessMap)
  fmt.Println(">>>>>> stateful:", actualStatefulMap)
  fmt.Println(">>>>>> num of NFW AZs:", nfwAzs)

  //intVar, err := strconv.Atoi(actualExample)
  //fmt.Printf(">>>>>>intVar, = %T\n", intVar)
  fmt.Printf(">>>>>>err, = %T\n", err)

	// website::tag::3::Check the output against expected values.
	// Verify we're getting back the outputs we expect
  assert.Equal(t, expectedStatelessMap, actualStatelessMap)
  assert.Equal(t, expectedStatefulMap, actualStatefulMap)
  assert.GreaterOrEqual(t, nfwAzs, minNumAzs)
}
