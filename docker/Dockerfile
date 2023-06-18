FROM ubuntu:focal
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy curl && \
    apt-get install -y unzip && \
    apt-get -y install jq && \
    apt-get -y install apt-transport-https ca-certificates gnupg    
RUN apt-get update && apt-get install -y gnupg wget    
    
# MongoDB Libmongocryptd and MOngoDB Enterprise
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.com/apt/ubuntu focal/mongodb-enterprise/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-enterprise.list
RUN wget -qO - https://www.mongodb.org/static/pgp/libmongocrypt.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/libmongocrypt.gpg
RUN echo "deb [ arch=amd64,arm64 ] https://libmongocrypt.s3.amazonaws.com/apt/ubuntu focal/libmongocrypt/1.7 universe" | tee /etc/apt/sources.list.d/libmongocrypt.list

RUN apt-get update && apt-get install -y mongodb-enterprise-cryptd python3.8 python3-pip libmongocrypt0
RUN python3 -m pip install -U pip

## AWS CLI
RUN apt install python-is-python3 -y
RUN apt install python3.8-venv -y
RUN apt-get update && \
    apt-get install -y \
        unzip \
        curl \
    && apt-get clean \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf \
        awscli-bundle.zip 

## Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

## GCP CLI
#RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
#RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
RUN apt-get install google-cloud-cli      
## Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg |  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update &&  apt install terraform -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y -qq groff

#Hashicorp Enterprise Vault
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.com/apt/ubuntu focal/mongodb-enterprise/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-enterprise.list
RUN wget -qO - https://www.mongodb.org/static/pgp/libmongocrypt.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/libmongocrypt.gpg
RUN echo "deb [ arch=amd64,arm64 ] https://libmongocrypt.s3.amazonaws.com/apt/ubuntu focal/libmongocrypt/1.7 universe" | tee /etc/apt/sources.list.d/libmongocrypt.list

RUN apt-get update && apt-get install -y mongodb-enterprise-cryptd python3.8 python3-pip libmongocrypt0
RUN python3 -m pip install -U pip
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN curl https://releases.hashicorp.com/vault/1.11.0-rc1+ent/vault_1.11.0-rc1+ent_linux_arm64.zip --output vault-ent.zip 
RUN unzip -qq vault-ent.zip
RUN cp vault /usr/bin/vault
RUN rm vault-ent.zip
RUN export VAULT_ADDR=http://127.0.0.1:8200
ENV AWS_PAGER=""
ENV AWS_DEFAULT_OUTPUT="json"
ENV AWS_DEFAULT_REGION="eu-central-1"
#RUN aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" && aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" && aws configure set region "$AWS_REGION" && aws configure set output "json"
CMD bash