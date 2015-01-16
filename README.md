README
======

This repository explores the use of Terraform to build isolated test environments. These test environments should be
secure with limited access from the public internet only to the intended HTTP interfaces. Security groups should
enforce network communications restrictions similar to a non-AWS DC setup.




TODO List
---------

* Learn about Cloud-Init - and use it to inject operational parameters into AWS pheonix server style setup
	- https://github.com/cloudius-systems/osv/wiki/cloud-init
	- especially how to inject RDS parameters into new app servers

* Figure out a faster way to get DNS entry (www-devX.composmin.net) available to creator

* DNS entries needed for hosts ??
	- could potentially make each different dev env have a different domain: like appserv1.dev1.composmin.net
	- has the advantage that DNS differences could be contained as a single value (/etc/resolve.conf) 
	and all other references use short name e.g. appserv1

* Richer Security Group
	* Per Subnet - which represents different platforms
	* block different platforms making changes to resources in other subnets

* VPC Peering
	* Alternative mechanism for platform protection
	* IAM restrictions may be simpler to implement


* Zero-downtime deployments

Helpful
-------
# Install the AWS & EC2 command line tools using the instructions at:
https://github.com/cloudius-systems/osv/wiki/Upload-OSv-AMI-from-EC2-instance
