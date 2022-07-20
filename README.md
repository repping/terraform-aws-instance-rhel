# One Hit Wonder: Just a simple AWS instance running RHEL 8

- ssh access is enabled by default
- internet access is enabled by default

## Pre-requirements

- AWS-cli installed with access to your AWS account.
- Red Hat account with a RHEL subscription. (Everyone can register for a Develeper subscription which allows registration of up to 16 RHEL instances. see: https://developers.redhat.com/articles/faqs-no-cost-red-hat-enterprise-linux)

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

5. Activate the Red Hat subscription, you will be prompted for your Red Hat Customer Portal password.
```
sudo subscription-manager register --username <username> --auto-attach
```
output:
```
[ec2-user@server ~]$ sudo subscription-manager register --username <username> --auto-attach
Registering to: subscription.rhsm.redhat.com:443/subscription
Password: 
The system has been registered with ID: f1d42f1e-1234-5678-9101-162b65498517
The registered system name is: <server-dns-name>.<aws-region>.compute.internal
Installed Product Current Status:
Product Name: Red Hat Enterprise Linux for x86_64
Status:       Subscribed

[ec2-user@server ~]$ 
```

6. unregistering:
```
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean
```

7. Clean up the deployment with: `terraform destroy`.
8. 