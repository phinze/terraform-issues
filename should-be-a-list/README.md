Reproduces a TF OSS bug where:

 * A module with computed output of type "list" is plumbed out to the top level
 * That output is passed back into a module as an input variable
 * That input variable is used in a resource that requires a list type paramter
 * Even though the input variable was declared as type "list", the resource
   complains about the type of the parameter.

Terraform Version: `0.9.4`

Steps to repro:

 * Get AWS creds in scope (they won't be used to make anything).
 * `terraform get`
 * `terraform plan`

Expect:

 * A happy plan

Get:

```
* module.inputlist.aws_elb.test: subnets: should be a list
```

Can be worked around by:

 * Wrapping the resource's parameter in square brackets. (Perhaps this needs to
   just be made required for all list references? If so then code should
  validate against the negative case, which is common in our configs since it
  usually works!)
