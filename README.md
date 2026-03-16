# Personal website using Angular and automatic deployment on AWS with Terraform and Github Actions

[![CI](https://github.com/hiagop22/personal-website/actions/workflows/ci.yaml/badge.svg)](https://github.com/hiagop22/personal-website/actions/workflows/ci.yaml)

This repository contains my personal website site built using **Angular, HTML5, CSS3, SASS**, with fully **automated CI/CD deployment to AWS** via **GitHub Actions** and [Terraform](https://www.terraform.io/).

🌐 Check out my personal website [https://aih.dev.br/](https://aih.dev.br/)!

## 🚀 CI/CD with GitHub Actions

The repository separates **infrastructure pipelines** and **application pipelines**.  
Workflows are also configured to run **only when changes are detected in specific folders**, avoiding unnecessary builds and speeding up the pipeline.

- **Terraform infrastructure CI**

    When a pull request modifies files in the `infrastructure/` folder, **Terraform** runs a `plan` so infrastructure changes can be reviewed before merging via [`infrastructure-ci.yaml`](.github/workflows/infrastructure-ci.yaml).

- **Terraform infrastructure CD**

    When infrastructure code is merged to `master`, the workflow applies the Terraform changes via [`infrastructure-cd.yaml`](.github/workflows/infrastructure-cd.yaml).

- **Angular build workflow**

    The Angular project build is implemented as a **reusable workflow** so it can be shared across multiple pipelines while keeping the configuration **DRY (Don't Repeat Yourself)** via [`build-angular.yaml`](.github/workflows/build-angular.yaml).

- **Website CI**

    The Angular application is automatically built and validated on pull requests when changes are detected in the `website/` folder.  
    This ensures the project compiles successfully before merging via [`website-ci.yaml`](.github/workflows/website-ci.yaml).

- **Website CD**

    After changes to the website are merged to `master`, the Angular application is built and uploaded to AWS S3 via [`website-cd.yaml`](.github/workflows/website-cd.yaml).

- **Main CI orchestrator**

    A top-level workflow [`ci.yaml`](.github/workflows/ci.yaml) acts as an **entry point for pull request pipelines**.  

    It exists primarily to support **GitHub branch protection status checks**, which require a consistent workflow to report the CI status for every pull request.

    Since the repository uses **path-based triggers**, the workflows [`infrastructure-ci.yaml`](.github/workflows/infrastructure-ci.yaml) and [`website-ci.yaml`](.github/workflows/website-ci.yaml) only run when changes are detected in their respective folders (`infrastructure/` or `website/`).  
    Because of this behavior, neither of them can reliably be used as a required **status check**, as they may not run at all for some pull requests.

    The orchestrator solves this by always running on pull requests and then evaluating which parts of the repository were modified before triggering the appropriate workflows.
  
    This keeps the CI configuration **DRY**, avoids duplicated trigger logic across workflows, and ensures that only the necessary pipelines run.

    Example behavior:
    ```
    Pull Request opened
        ↓
    ci.yaml
        ↓
    Detect changed paths
        ↓
    infrastructure/** → infrastructure-ci.yaml
    website/** → website-ci.yaml
    ```

    Because some jobs run conditionally, the pipeline also includes a final aggregation step called final_status.

    This job collects the results of all pipelines triggered by the orchestrator and produces a single deterministic CI result used by GitHub branch protection rules.

    This guarantees that:

    - If any triggered pipeline fails, the CI fails.
    - If a pipeline is skipped because no relevant files changed, the CI still succeeds.
    - Branch protection rules can rely on one consistent status check.
    
    The final execution flow looks like this:
    ```
        Pull Request opened
            ↓
        ci.yaml
            ↓
        detect_changes
            ↓
    ┌──────────────────────────────┐
    ↓                              ↓
    website_ci               infrastructure_ci
    ↓                              ↓
    └───────────┬──────────────────┘
                ↓
            final_status
    ```

    The final_status job is configured as the required status check in the repository’s branch protection rules, ensuring that pull requests can only be merged once all relevant CI pipelines have completed successfully.
    
All infrastructure planning and application are automated using **GitHub Actions**. 
The pipeline is designed to separate **infrastructure pipelines** and **application pipelines**, while keeping workflows reusable and maintainable.

✅ No more local scripts or manual `bash` commands for deploys — the deployment pipeline is now fully managed in the cloud. All the workflows can be found in [.github/workflows/](.github/workflows/)


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


## 🧰 Requirements (for local website development)


This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.2.0.

To simplify local development and avoid needing to push commits or trigger the CI/CD pipeline just to verify changes, this repository includes a helper script:

[`website/local.sh`](website/local.sh)

This script builds and serves the project locally in a way that closely mirrors the production configuration, allowing quick feedback during development.


### 1. Install Node using NVM

Use [nvm](https://github.com/nvm-sh/nvm) to manage Node versions:
With nvm installed, run

```shell
nvm install v20.11.1
nvm use v20.11.1
npm install
```

### 2. Run the website locally

Instead of manually running Angular commands each time, you can start the local development environment using:

[`website/local.sh`](website/local.sh)

This script handles the necessary steps to start the Angular development server so you can preview the website locally without needing to deploy changes to AWS or merge branches.

The website will be available at:

http://localhost:4200

This makes it easier to iterate quickly and verify changes before committing or triggering the CI/CD pipeline.

## 🧰 Requirements (for local infrastructure development)

### Credentials
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
