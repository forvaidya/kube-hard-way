# Terraform Instructions
Basic boiler plate is ready. 
Githib AWS role is created, Backend stuff (bucket | dynamo)

#Objective: 
To make EC2 instance for some kuberenetes installation

#Task
Make a VPC with a reasonable cider block and only 1 public subnet. 
Create 3 VMS with following specs

AMI: ami-0f5ee92e2d63afc18 (ap-south-1)
OS: Ubuntu Server 22.04 LTS
Architecture: x86_64

Give each machine a unique name apiserver, node1 and node2

I will supply key pair value in variables and tfvars 
No default 
Please collect the output Vpc id

