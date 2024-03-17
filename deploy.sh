#!/bin/bash

DOMAIN="aih.dev.br"

cd website
ng build  --base-href "https://${DOMAIN}"
cd ..
cd terraform
terraform plan -out="tfplan.out"
terraform apply "tfplan.out"