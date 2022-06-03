# One Hit Wonder: Just a simple AWS instance running RHEL 8

- ssh access is enabled by default
- internet access is enabled by default

## Pre-requirements

- aws-cli installed with access to your AWS account

## How to connect

1. Generate a local ssh keypair:

```
ssh-keygen
```
output:
```
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/richard/.ssh/id_rsa): ./sshkey 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./sshkey
Your public key has been saved in ./sshkey.pub
The key fingerprint is:
SHA256:/EQb6mZ9omElLEcdiQEFltM2blIAs6VE6qkVI4CNDPA richard@richards-MacBook-Pro.fritz.box
The key's randomart image is:
+---[RSA 3072]----+
|Oo .=.*Boo..     |
|+o.o *o *...     |
```

2. Add the filename of the public-key you just generated to the `aws_instance.main` resource block in `main.tf`.

3. Run `terraform apply`

4. The Terraform output will tell you how to connect to the instance, this will be displayed after running `terraform apply`.