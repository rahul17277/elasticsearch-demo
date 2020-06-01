# Elasticsearch cluster with Terraform

This document describes how to setup an elasticsearch cluster of EC2 instances using Terraform.

## EC2 Discovery Plugin

The [EC2 Discovery Pluging](https://www.elastic.co/guide/en/elasticsearch/plugins/current/discovery-ec2.html)
is used by Elasticsearch to find nodes in AWS. The EC2 discovery plugin uses the AWS API for discovery.
EC2 discovery requires making a call to the EC2 service. So, a IAM Role is necessary for this plugin to find other nodes
in the cluster.

Since we are using Terraform, we will need to create few things for our cluster to work properly. First of all, our 
cluster will have 3 instances running Elasticsearch 5.6.3 + EC2 Discovery Plugin. Also, this instance needs to be able 
to call the AWS API to find other nodes, for that we will use an IAM Role. Those instances will stay under a security group
named **elasticsearch-sg** that has exposed port 22, 9200 and 9300 (for SSH, Elasticsearch API endpoint and Elasticsearch 
internal communication, respectively).

### Attaching roles to instances with Terraform
We created a `aws_iam_policy_document` that describes our policy, this policy document is used by an `aws_iam_policy`. 
This policy will then be attached to an `aws_iam_role` using `aws_iam_role_policy_attachment`. Then, we create an 
`aws_iam_instance_profile` that will reference our IAM Role. Finally, our instances can reference `iam_instance_profile`
and will be able to reach out the AWS API.

## Setup Script
The `elasticsearch-node-setup.sh` scripts installs Java 8 and Elasticsearch 5.6.3 on Red-Hat based machines.
Also, it configures some other flags in order for the node to be properly setup. Those flags are: 

- `discovery.zen.hosts_provider`: discovery mechanism in Elasticsearch (for it to work in AWS, this
flag is set to `ec2`
- `cloud.aws.region`: AWS region where the cluster will be deployed
- `network.host`: currently using the private IP address of the instance (`_ec2_`), but there are few
options available. Check out the [EC2 Network Host documentation](https://www.elastic.co/guide/en/elasticsearch/plugins/current/discovery-ec2-discovery.html#discovery-ec2-network-host)
for more information. 

All those flags are set in `/etc/elasticsearch/elasticsearch.yml`.

**Note that in order for these Terraform templates to work, you will need to provide an AWS AMI (Amazon linux or any
Red-Hat-based image) as well as your secret and access keys.**

