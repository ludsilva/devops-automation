#!/bin/bash

KEY_NAME="devops-keypair"
SG_NAME="devops-sg-ie"

VPC_ID=$(aws ec2 describe-vpcs \
  --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" --output text)

SUBNET_ID=$(aws ec2 describe-subnets \
  --filters Name=default-for-az,Values=true \
  --query "Subnets[0].SubnetId" --output text)

AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
  --output text)

# Verifica se a keypair já existe na AWS
aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Criando keypair $KEY_NAME"
  aws ec2 create-key-pair --key-name "$KEY_NAME" \
    --query 'KeyMaterial' --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
else
  echo "Keypair $KEY_NAME já existe na AWS. Pulando criação."
  if [ ! -f "$KEY_NAME.pem" ]; then
    echo "Arquivo local $KEY_NAME.pem não existe. Crie manualmente ou baixe da criação original."
    exit 1
  fi
fi

# Criar security group
SG_ID=$(aws ec2 create-security-group \
  --group-name "$SG_NAME" \
  --description "Acesso via loop" \
  --vpc-id "$VPC_ID" \
  --query 'GroupId' --output text)

# Liberar porta 22
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0

# Lista de nomes
VMS=(vm01 vm02 vm03)

for NAME in "${VMS[@]}"; do
  echo "Criando instância: $NAME"

  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type t2.micro \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --subnet-id "$SUBNET_ID" \
    --associate-public-ip-address \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME}]" \
    --query 'Instances[0].InstanceId' --output text)

  echo "$NAME criada com ID: $INSTANCE_ID"

  # Aguardar a instância estar pronta
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
  echo "$NAME está em execução"
done