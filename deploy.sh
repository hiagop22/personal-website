#!/bin/bash
set -e

DOMAIN="aih.dev.br"

# nvm use v20.11.1
tfenv use 1.11.1

cd website
ng build  --base-href "https://${DOMAIN}"
cd ..
cd terraform
terraform plan -out="tfplan.out"
terraform apply "tfplan.out"