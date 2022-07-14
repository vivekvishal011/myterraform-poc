# myterraform-poc

`` Terraform snippet for deploying ASG in private subnet behind ALB ``
Below is the architecture to be implemented:
![image](https://user-images.githubusercontent.com/88605079/178881982-87533c6d-96b3-4f79-9b3e-12f835ad5135.png)
The files included are:
a)  main.tf: main.tf file contains the terraform script to create necessary resources.
b)  variables.tf: for declaring variables being used in the main script
c)  terraform.tfvars: for defining/overriding the varibles
d)  init_webserver.sh: User data script for launch config which installs & starts nginx server and creates mount points
` (notes;--for more details to create alb and autoscaling with vpc ,sg,igw,route table,eip,etc to understand more use this link:-
   https://aws.plainenglish.io/provisioning-aws-infrastructure-using-terraform-vpc-private-subnet-alb-asg-118b82c585f2) `

`` Prerequisites: ``
1. AWS account
2. IAM role with necessary permissions
3. Terraform & AWS CLI configured on machine from which the scripts are to be run `
(to install the terraform on our server for detail use this link:-
https://www.terraform.io/downloads)

` state.tf `
We'll create all of the necessary resources without declaring the S3 backend. The order of the following list of resources to be created is not important.:
KMS key to allow for the encryption of the state bucket
KMS alias, which will be referred to later
S3 bucket with all of the appropriate security configurations

inside of state.tf file contains are=

<img width="967" alt="Screenshot 2022-07-14 at 7 37 51 AM" src="https://user-images.githubusercontent.com/88605079/178882739-1a28dfc5-7cc4-4eff-a8be-687adda3c782.png">

S3 bucket
To create a secure bucket, we create the two following resources:
<img width="848" alt="Screenshot 2022-07-14 at 7 30 57 AM" src="https://user-images.githubusercontent.com/88605079/178882894-59df4bac-daf4-4c58-85ab-159b42bdc8a1.png">
Now, change the bucket name, BUCKET_NAME to whatever you prefer. Next, let’s jump into the two resources because there’s a lot to cover.

The first resource, aws_s3_bucket, creates the required bucket with a few essential security features. We turn versioning on and server-side encryption using the KMS key we generated previously.

The second resource, aws_s3_bucket_policy_access_block, guarantees that the bucket is not publicly accessible.
`for sns'
So it will be easy to setup Alarms and create SNS topic to send alert to an email with one
<img width="705" alt="Screenshot 2022-07-14 at 7 58 07 AM" src="https://user-images.githubusercontent.com/88605079/178885046-3510c53d-de59-4943-8df2-aa2b59abb6ea.png">


` rds.tf `
create an RDS instance is very easy. Put the following in an  file, such as rds.tf:
To create a DB subnet group you should use the aws_db_subnet_group resource. You then refer to it by name directly when creating database instances or clusters.
<img width="744" alt="Screenshot 2022-07-14 at 8 04 59 AM" src="https://user-images.githubusercontent.com/88605079/178885869-520cc270-dd63-45e9-8eda-26226dcd3dbd.png">
` (for more details;- https://stackoverflow.com/questions/59239970/terraform-error-creating-subnet-dependency) '
` redis.tf '
Affected Resource(s)
aws_elasticache_cluster
aws_elasticache_subnet_group
Terraform Configuration Files for elasticcache
<img width="828" alt="Screenshot 2022-07-14 at 8 10 39 AM" src="https://user-images.githubusercontent.com/88605079/178886545-4116bd6b-d6db-4868-b2da-29541ee5a6c7.png">

` this will give an error same like rds block to resolve the error need to create parameter group with family like redis 6.0.x... `
<img width="865" alt="Screenshot 2022-07-14 at 8 14 56 AM" src="https://user-images.githubusercontent.com/88605079/178887068-bfb3031b-5dbc-469f-ad7a-ae9ce5d5ac00.png">

`(for more details use this link:-https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group)`
` for more details about elasticcache;-https://github.com/hashicorp/terraform-provider-aws/issues/1171 `

` AFTER setting all we are gud to go for that we need to follow this steps:
` First Terraform Run `
`Now that we have code written out for all of the core resources we’ll need, it is time to run out first Terraform commands. We’ll start with a terraform init to prepare our environment, followed by a terraform apply to “apply” our resources in AWS.`
`terraform init`
The most important output from this command is the following:
<img width="929" alt="Screenshot 2022-07-14 at 8 24 15 AM" src="https://user-images.githubusercontent.com/88605079/178888157-76e5ba21-523f-4e97-84ff-7bafd3aa1bde.png">
``after that ``
<img width="1070" alt="Screenshot 2022-07-14 at 8 34 32 AM" src="https://user-images.githubusercontent.com/88605079/178889397-c10b7538-9456-4bb6-a1bc-00b082299303.png">

`So far, so good. We’ve created all of the necessary underlying resources required to store our Terraform state file securely in an AWS S3 bucket. However, if we look in the directory where our source files are, you will see the state file is currently being stored locally as terraform.tfstate.

We have to add one more resource to our state.tf file, rerun terraform apply, and everything should turn out as expected. Let’s start by adding the following to the top of the state.tf file.`
`` terraform {
 backend "s3" {
   bucket         = "<BUCKET_NAME>"
   key            = "state/terraform.tfstate"
   region         = "us-east-1"
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state"
 }
} ``

<img width="1073" alt="Screenshot 2022-07-14 at 8 38 37 AM" src="https://user-images.githubusercontent.com/88605079/178889782-84a999d8-2c0b-4684-bdc8-e357d9089df6.png">

` now we all set to go 
run the terraform script again via `
`terraform init (if ask then type YES and hit enter)`
`terraform plan`
`terraform apply` 
`will see the results `

``Once you get the expected outcome of terraform plan , you are good to execute terraform apply. Later on, you can go to AWS VPC, EC2, and respective services dashboards to verify the changes. Finally, once you hit the AWS-generated load balancer hostname URL, you should be able to view the Nginx homepage.``

`` for more details use this link ;-
https://aws.plainenglish.io/provisioning-aws-infrastructure-using-terraform-vpc-private-subnet-alb-asg-118b82c585f2``

`Happy Terraform-ing!`












