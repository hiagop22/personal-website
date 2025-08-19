# Personal website using Angular and automatic deployment on AWS with Terraform and Github Actions

This repository contains my personal website site built using **Angular, HTML5, CSS3, SASS**, with fully **automated CI/CD deployment to AWS** via **GitHub Actions** and [Terraform](https://www.terraform.io/).

🌐 Check out my personal website [https://aih.dev.br/](https://aih.dev.br/)!

## 🚀 CI/CD with GitHub Actions
All infrastructure planning and application are automated using **GitHub Actions**. The workflow includes:

- Building the Angular app via: [build-angular.yaml](.github/workflows/build-angular.yaml)
- Planning infrastructure changes using **Terraform**
- Applying infrastructure on merge to `master`: [terraform-apply.yaml](.github/workflows/terraform-apply.yaml)
- Uploading and cleaning up artifacts: [clean-up.yaml](.github/workflows/clean-up.yaml)
- Reusing jobs across workflows to keep things DRY

✅ No more local scripts or manual `bash` commands — the deployment pipeline is now fully managed in the cloud. All the workflows can be found in [.github/workflows/](.github/workflows/)


## ✅ Best Practices Followed
- **Commit conventions:** commits should be clear and meaningful (e.g., `fix: broken S3 config`, `feat: enable gzip in CloudFront`)
- **Reusable workflows:** common tasks like building Angular or cleaning up artifacts are abstracted into separate workflow files (`workflow_call`) and reused across jobs
Artifact cleanup: builds are automatically cleaned up post-deployment to avoid bloated storage and unnecessary retention
- **Branch-based automation:** 
    - `pull_request` triggers a Terraform plan for review
    - `push` to `master` triggers deployment
- **Secure secrets:** AWS credentials are stored using GitHub Secrets and passed through the environment securely
Conditional job execution: cleanup and reporting jobs use `if: always()` to ensure proper execution even on failure


## ✅ GitHub Actions Best Practices Followed
In addition to the CI/CD pipeline setup, this repository follows key GitHub Actions best practices for security, reliability, and performance:

- **Workflow timeouts** – All jobs have `timeout-minutes` set to prevent stuck builds.
- **Concurrency control** – Normally used to cancel in-progress jobs when a newer one is triggered, but **not applied here** to avoid conflicts with Terraform's state locking mechanism.
- **Restricted permissions** – Workflows explicitly request only the minimal GitHub token permissions required (`contents: read`).
- **Pinned action versions** – All actions are pinned to commit SHAs instead of floating tags for security and reproducibility.
- **Trusted third-party actions** – Only actions from trusted maintainers are used, and dependencies are evaluated before adoption.
- **Versioned runners** – Workflows run on `ubuntu-22.04` instead of `ubuntu-latest` to avoid unexpected environment changes.
- **Secure secrets management** – AWS credentials and other sensitive data are stored in GitHub Encrypted Secrets and scoped to necessary workflows.
- **Dependency caching** – No separate actions/cache step is configured for npm dependencies, because actions/setup-node v4 is already used with its built-in caching mechanism.
- **Readable YAML** – Workflow files are organized, and reusable jobs are centralized to keep pipelines maintainable.


## 🧱 AWS Infrastructure
Using Terraform, the following AWS services are provisioned:

- **S3** - static hosting for the Angular site
- **CloudFront** - global CDN distribution
- **Route53** - DNS routing for custom domain
- **ACM** - automatic HTTPS via SSL certificates
- **IAM** - scoped permissions for secure access

## 📚 Learning Goals
While Terraform is used for infrastructure, this project is primarily a **learning exercise** combining frontend development and DevOps concepts. It's part of my hands-on practice from:

- [Curso HTML5 e CSS3.- Módulo 1 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dkZ9-atkcmcBaMZdmLHft8n)
- [Curso HTML5 e CSS3.- Módulo 2 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dlUpEXkY1AyVLQGcpSgVF8s)
- [Curso HTML5 e CSS3.- Módulo 3 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLGoULRt59zHtHG1tQUjucsOmeqiwo2FWr)
- [Curso HTML5 e CSS3.- Módulo 4 de 5 - Curso em Vídeo](https://www.youtube.com/playlist?list=PLHz_AreHm4dkcVCk2Bn_fdVQ81Fkrh6WT)


## 🧰 Requirements (for local development)


This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.2.0.
To run the project locally:

**1.** Use [nvm](https://github.com/nvm-sh/nvm) to manage Node versions:
With nvm installed, run

```shell
nvm install v20.11.1
nvm use v20.11.1
npm install
ng run ng serve
```

**2.**  Configure AWS Credentials
To allow Terraform to interact with AWS, you must provide valid credentials. You can do this in two ways:

**✅ Option A: Using environment variables**

```shell
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```
**✅ Option B: Using the AWS CLI and credentials file**
Ensure you’ve installed and configured the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), then run:

```shell
aws configure
```
This creates a `~/.aws/credentials` file that Terraform and other tools will use by default.

**⚠️ Never commit AWS credentials** or `.aws` **folders to version control** — always use `.gitignore`.

**3.** Use [tfenv](https://github.com/tfutils/tfenv) to manage Terraform:

```shell
tfenv use 1.7.1
terraform init
terraform validate
terraform plan -out=tfplan.out
terraform apply tfplan.out
```

💡 `terraform plan -out=tfplan.out` creates an executable plan file that you can later apply with `terraform apply tfplan.out`. This helps separate the planning and execution steps, reducing risks during production changes.


**4.** Destroy infrastructure (🔥 DANGER ZONE):

To remove all resources deployed via Terraform, run:

```bash
terraform destroy
```
This will **permanently delete everything**, including S3 buckets, CloudFront distributions, and DNS records.
