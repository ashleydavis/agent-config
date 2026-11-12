# AWS rules

These rules apply to any work with an AWS account: the AWS CLI, an SDK, the console or any other way of calling AWS.

- Never attempt to modify live AWS state, and never ask to. Read-only calls are the only AWS calls the agent makes. Changes to AWS go through the project's own deploy workflows, started only when the human asks for them.
