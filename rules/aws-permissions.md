# AWS permissions rules

These rules apply when writing or changing AWS IAM policies.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

- Give each statement a simple Sid that describes why its permissions are required.
- Add a `"Comment"` key to each statement only when the surrounding Terraform project has code that removes it before the policy is given to AWS. The comment explains why the statement's permissions are required. Keep it up to date as the permissions change.
