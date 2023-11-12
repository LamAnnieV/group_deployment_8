# Title 

November 5, 2023

Group Name:

Group Members:  

Annie V Lam - Project Manager

Sameen Khan - Chief Architect

Jorge Molina - System Administrator

# Purpose

Deploy E-Commerce Application in ECS Container 

## Step  AWS Setup (Jorge)
# AWS Setup

Since we are working in a group, I had to set up AWS user accounts for my team members to collaborate on the same servers. I created two user accounts, copying the same permissions from myself. This allows my team members to create and access EC2 instances.

## Step  Diagram the VPC Infrastructure and the CI/CD Pipeline (Sameen)

![Deployment Diagram](Images/Deployment_Pipeline.png)

## Step 2 GitHub/Git (Annie)

**Setup GitHub Repository for Jenkins Integration:**

GitHub serves as the repository from which Jenkins retrieves files to build, test, and build the infrastructure for the e-commerce application and deploy the e-commerce application.  [GitHub repository](https://github.com/LamAnnieV/group_deployment_8.git)

In order for the EC2 instance, where Jenkins is installed, to access the repository, you need to generate a token from GitHub and then provide it to the EC2 instance.

[Generate GitHub Token](https://github.com/LamAnnieV/GitHub/blob/main/Generate_GitHub_Token.md)

With three collaborators on this project, in order to minimize merge conflicts, each collaborator creates a branch and works off of that branch.  The merge to the main repo will be done in GitHub in the [project GitHub repository](https://github.com/LamAnnieV/group_deployment_8.git)

## Step # Python Script (Jorge)

## Step # Docker/Dockerfile  (Jorge)
# Dockerfile.BE:

For this project, we created a Dockerfile for the backend containers in our ECS cluster. Once the Dockerfile was created and configured for our backend image, I used `docker build` to build the image. Following that, I used `docker image ls` to confirm that the image was successfully built. Upon verification, I used `docker image tag` with the old image ID and the new image name, incorporating my DockerHub username. Once the image was correctly named and built, I pushed it to my DockerHub repository using `docker push`. The backend image used the following configurations:

# Dockerfile.FE:

For this project, we created a Dockerfile for the frontend containers in our ECS cluster. Similar to the backend setup, after creating and configuring the Dockerfile for our frontend image, I used `docker build` to build the image and `docker image ls` to check its successful creation. After confirming the image build, I utilized `docker image tag` to assign a new name with my DockerHub username included. Subsequently, I pushed the image to my DockerHub repository using `docker push`. The frontend image used the following configurations:

A Docker image is a template of an application with all the dependencies it needs to run. A docker file has all the components to build the Docker image.

For this deployment, we need to create a [dockerfile](dockerfile) to build the image of the e-commerce application.  Please see the [GIT - docker file](Images/git.md) section to see how to test the dockerfile to see if it can build the image and if the image is deployable.


## Step # Terraform (Sameen)

Terraform is a tool that helps you create and manage your infrastructure. It allows you to define the desired state of your infrastructure in a configuration file, and then Terraform takes care of provisioning and managing the resources to match that configuration. This makes it easier to automate and scale your infrastructure and ensures that it remains consistent and predictable.

### Jenkins Agent Infrastructure (Sameen)

Use Terraform to spin up the [Jenkins Agent Infrastructure](jenkinsTerraform/main.tf) to include the installs needed for the [Jenkins instance](jenkinsTerraform/installs1.sh), the install needed for the [Jenkins Docker agent instance](jenkinsTerraform/installs2.sh), and the install needed for the [Jenkins Terraform agent instance](jenkinsTerraform/installs3.sh).

**Use Jenkins Terraform Agent to execute the Terraform scripts to create the E-Commerce Application Infrastructure and Deploy the application on ECS with Application Load Balancer**

#### E-Commerce Application Infrastructure (Semeen)

Create the following [e-commerce application infrastructure](intTerraform/vpc.tf):  

```
1 VPC
2 Availability Zones (AZ)
2 Public Subnets
2 Containers for the frontend
1 Container for the backend
1 Route Table
Security Group Ports: 8000, 3000, 80
1 ALB
```

#### Elastic Container Service (ECS) (Sameen)

Amazon Elastic Container Service (ECS) is a managed container orchestration service.  It is designed to simplify the deployment, management, and scaling of containerized applications using containers. The primary purpose of ECS with Docker images is to make it easier to run and manage containers in a scalable and reliable manner.

AWS Fargate is a technology that you can use with Amazon ECS to run containers without having to manage servers or clusters of Amazon EC2 instances. With Fargate, you no longer have to provision, configure, or scale clusters of virtual machines to run containers.

Create the following resource group for [Elastic Container Service](intTerraform/main.tf):  

```
aws_ecs_cluster - for grouping of tasks or services
aws_cloudwatch_log_group
aws_ecs_task_definition - describes the container
aws_ecs_service - is a fully managed opinionated container orchestration service that delivers the easiest way for organizations to build, deploy, and manage containerized applications at any scale on AWS
```

#### Application Load Balancer (ALB) (Sameen)

The purpose of an Application Load Balancer (ALB) is to evenly distribute incoming web traffic to multiple servers or instances to ensure that the application remains available, responsive, and efficient. It directs traffic to different servers to prevent overload on any single server. If one server is down, it can redirect traffic to the servers that are still up and running.  This helps improve the performance, availability, and reliability of web applications, making sure users can access them without interruption, even if some servers have issues.

Create the following [Application Load Balancer](intTerraform/ALB.tf):  

```
aws_lb_target_group - defines the target group
aws_alb" "e_commerce_app - load balancer
aws_alb_listener - what port is the application load balancer listening on

```

## Step # Jenkins (Annie)

### Jenkins

Jenkins automates the Build, Test, and Deploy the E-Commerce Application.  To use Jenkins in a new EC2, all the proper installs to use Jenkins and to read the programming language that the application is written in need to be installed. In this case, they are Jenkins, Java, and Jenkins' additional plugin "Pipeline Keep Running Step", which is manually installed through the GUI interface.

**Setup Jenkins and Jenkins nodes**

[Create](https://github.com/LamAnnieV/Create_EC2_Instance/blob/main/Create_Key_Pair.md) a Key Pair

Configure Jenkins

Instructions on how to configure the [Jenkin node](https://github.com/LamAnnieV/Jenkins/blob/main/jenkins_node.md)

![images]/(Images/Jenkin_Nodes.png)

Instructions on how to configure [AWS access and secret keys](https://github.com/LamAnnieV/Jenkins/blob/main/AWS_Access_Keys), that the Jenkin node will need to execute Terraform scripts

Instructions on how to configure [Docker credentials](https://github.com/LamAnnieV/Jenkins/blob/main/docker_credentials.md), to push the docker image to Docker Hub

![image](Images/Jenkins_Global_Credentials.png)

Instructions on how to install the [Pipleline Keep Running Step](https://github.com/LamAnnieV/Jenkins/blob/main/Install_Pipeline_Keep_Running_Step.md)

Instructions on how to install the [Docker Pipeline](https://github.com/LamAnnieV/Jenkins/blob/main/Install_Docker_Pipeline_Plugin.md)


### Jenkins Build for E-Commerce Backend and Frontend Application

This application has two tiers, the frontend is the web layer and the backend are application and database layer.  To connect the frontend to the backend, the backend needs to be created first so that the private IP address of the backend task can be passed to the file package.json:

**Jenkins Build for E-Commerce Application Backend (JenkinsfileBE)**  (Annie)

Jenkins Build:  In Jenkins create a build "Group_Deploy_8_JenkinsBE" to run the file JenkinsfileBE for the E-Commerce application from [GitHub Repository](https://github.com/LamAnnieV/group_deployment_8.git) and run the build.  This build consists of the following stages:

Docker "Build" - this stage builds the backend image from the be.Dockerfile file

"Login and Push" - this stage login Docker Hub with the credentials saved in the Jenkins Global Credentials

Terraform "Init" - this stage passes the AWS Access Key and Secret Key from the Jenkins Global Credentials, goes into the directory where the terraform files for the backend are located, then initializes the working directory

Terraform "Plan" - this stage in addition to the first and second part of the stage above, also, creates an execution plan

Terraform "Apply" - this stage in addition to the first and second part of the stage above, also, executes the actions proposed in a terraform plan

![image](Images/Jenkins_BE_Build.png)

**Pass the IP Address of the backend task to the package.json file** - which allows the frontend to proxy into the backend 

![image](Images/proxy.png)

**Jenkins Build for E-Commerce Application Frontend (JenkinsfileFE)**

The stages for the frontend is the same as the backend, the differences are the dockerfile for the frontend creates the image for the frontend, and the terraform files

![image](Images/Jenkins_FE_Build.png)

VPC Resource Map

![image](Images/Resource_map.png)

Cluster

![image](Images/Clusters.png)

Services

![image](Images/Services.png)

Tasks

![image](Images/Tasks.png)

**Results:**

![Image](Images/Jenkins.png)

The application was launched with the DNS:

![Images](Images/Launched_website.png)

## Issue(s) (All)

1.  

## Conclusion (All)

What is the application stack of this application?

Is the backend an API server?


## Area(s) for Optimization (All)



Note:  ChatGPT was used to enhance the quality and clarity of this documentation
  

