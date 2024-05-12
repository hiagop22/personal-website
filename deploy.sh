#!/bin/bash

DOMAIN="aih.dev.br"

tfenv use 1.7.1

cd website
ng build  --base-href "https://${DOMAIN}"
cd ..
cd terraform
terraform plan -out="tfplan.out"
terraform apply "tfplan.out"