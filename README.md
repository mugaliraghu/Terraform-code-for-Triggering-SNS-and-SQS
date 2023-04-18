# Terraform-code-for-Triggering-SNS-and-SQS

## What it is?
This terraform file creates several resources, including an SNS topic, an SQS queue, and an EventBridge rule 
that filters for certain events and sends those events to the SNS topic and SQS queue. The resources are defined 
using the terraform resource.

## Where it is useful?
This Terraform file  is useful for creating a serverless application on AWS that uses EventBridge to filter and route events to 
an SNS topic and an SQS queue. 

SNS (Simple Notification Service) is a fully managed messaging service provided by AWS that enables the publishing and subscribing of messages 
from various services or systems. 
SQS (Simple Queue Service) is a fully managed message queuing service that enables decoupling and scaling of microservices, 
distributed systems, and serverless applications. 
EventBridge is a serverless event bus that can be used to integrate AWS services, SaaS applications, and custom applications.

Using main.tf file, you can define an EventBridge rule that filters for certain events and sends those events to an SNS topic and an SQS queue. 
The SNS topic can be used to send notifications to subscribers via email, SMS, or other protocols, 
while the SQS queue can be used to store and process the messages asynchronously. This can be useful for building real-time monitoring and alerting systems, as well as decoupled and scalable serverless architectures.

first navigate to file where main.tf is present and perform below command. it performs backend initialization, and plugin installation.
```t
terraform init
```
then, use need to use the below command to validate the file
```t
terraform validate
```
and terraform plan will generate execution plan, showing you what actions will be taken without actuallay performing planned actions.
```t
terraform plan
```
after perform below command to deploy the application in aws and '--auto-approve' applying changes without having to interactively type 'yes' to the plan.
```t
terraform apply --auto-approve
```
The resource that are creating after doing terraform apply as shown in below image.
![Screenshot (34)](https://user-images.githubusercontent.com/120295902/232740479-98528ca0-f31e-4b22-9455-9f0ce4328f9f.png)
## Validation steps

How i will get the notification as shown in below images.
### The image it is in stopped state
<img width="842" alt="instance_stopped state" src="https://user-images.githubusercontent.com/120295902/232736384-cd47ba2d-4f33-4bc9-b4f9-3bd886d8f569.png">
Now i am going to start this instance manually, then the notification in got as shown below
### The screenshorts that i got a notification form SNS topic and Email subscription.
![Screenshot (28)](https://user-images.githubusercontent.com/120295902/232382197-761c170a-aed5-4af0-b4b2-6cfe8f4bbd97.png)

![Screenshot (32)](https://user-images.githubusercontent.com/120295902/232382345-afc8426a-4de6-43ff-a60d-47c503fbae0c.png)
### The screenshorts that i got form SQS queue.
![Screenshot (30)](https://user-images.githubusercontent.com/120295902/232382754-bfc0a90a-f4a4-4ef1-95c8-9ceb646f907d.png)

![Screenshot (29)](https://user-images.githubusercontent.com/120295902/232382572-6ea99cba-610c-4368-a24c-b7fc8bc80640.png)


to destroy this application use belo command
```t
terraform destroy --auto-approve
```
