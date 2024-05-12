# Personal website using Angular and automatic deployment on AWS with terraform

This repository demonstrates a simple project showcasing how I created my own site using Angular, HTML5, CSS3, SASS and made
automatic deployment on AWS using [Terraform](https://www.terraform.io/).

🌐 Check out my personal website [https://aih.dev.br/](https://aih.dev.br/)!

In terraform, the following resources are used
- CloudFront for CDN Service
- Route53 for DNS service so that I can use own domain
- S3 for static hosting  
- ACM for management of SSL/TLS certificates
- IAM for minimum privileges applied

Although this repository has Terraform files, this project aims to apply the subjects learned  into the following course playlists:
- [Curso HTML5 e CSS3.- Módulo 1 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dkZ9-atkcmcBaMZdmLHft8n)
- [Curso HTML5 e CSS3.- Módulo 2 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dlUpEXkY1AyVLQGcpSgVF8s)
- [Curso HTML5 e CSS3.- Módulo 3 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLGoULRt59zHtHG1tQUjucsOmeqiwo2FWr)
- [Curso HTML5 e CSS3.- Módulo 4 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dkcVCk2Bn_fdVQ81Fkrh6WT)

## AWS Infrastructure

First of all, export your AWS credentials to your shell using:
```shell
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export REGION=""
```

## Requirements

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.2.0.

First of use the terraform script, check if you have the specified terraform version, which is 1.7.1.
It is recommended to manage terraform versions across many projects using [tfenv](https://github.com/tfutils/tfenv).
With tfenv installed, use:

```shell
tfenv use 1.7.1
terraform init
terraform validate
```

To manage Node across many projects, it is recommended to use [nvm](https://github.com/nvm-sh/nvm).
With nvm installed, run

```shell
nvm use v20.11.1
```

and then run the [deploy.sh](deploy.sh) script to deploy a new version of the website on AWS.

Remember to clear the browser cache when updating the page or use an incognito tab to test the redeploys.


### Destroying
Be aware that using the command bellow, `ALL` resources created by terraform code will be destroyed:
```shell
terraform destroy
```
