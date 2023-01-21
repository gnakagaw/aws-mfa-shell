# aws mfa shell
easy access to [awscli](https://aws.amazon.com/cli/) with MFA enabled account.

## Background and Mechanism
[awscli](https://aws.amazon.com/cli/) is a CLI tool to access AWS API. Basically, We can authenticate with [a pair of access key id and secret access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) in using awscli. However, [it is required MFA code authentication](https://aws.amazon.com/jp/premiumsupport/knowledge-center/authenticate-mfa-cli/) based on the target aws environment settings.

This script executes a MFA authentication flow and launch a shell with acquired temporary credentials. You can use awscli with no additional settings under the launched shell. When you exit the authenticated shell, the credentials will be disposed.

NOTE: You can use only virtual MFA device such as Google Authenticator. U2F device (e.g. YubiKey) is unsupported [due to aws specifications](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_credentials_mfa_u2f_supported_configurations.html#id_credentials_mfa_u2f_cliapi).

## Usage
First of all, please set your aws access credential to awscli. There are several method: [configuratin file](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html), [environment variables (e.g. `AWS_ACCESS_KEY_ID`)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html). Of courese, it is okay to modify this script as you like to authenticate awscli.

Execute the script as below
```
$ ./aws_mfa_shell.sh
MFA code? XXXXXX <- input token from your MFA device
$ aws ec2 describe-instances
(API result...)
```

If you have some trouble, the script outputs an error message and stops. Please check your configuration and this script.
```
$ ./aws_mfa_shell.sh
MFA code? 11111111111111
Failed to get temporary access credentials. Abort.

message from aws-cli:
An error occurred (ValidationError) when calling the GetSessionToken operation: 1 validation error detected: Value '11111111111111' at 'tokenCode' failed to satisfy constraint: Member must have length less than or equal to 6
$
```
