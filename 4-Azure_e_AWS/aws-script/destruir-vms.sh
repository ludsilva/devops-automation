#!/bin/bash

export AWS_PAGER=""

KEY_NAME="devops-keypair-01"
SG_NAME="devops-sg-ie"

# Lista de nomes criados
VMS=(vm01 vm02 vm03)

# Identificar os Instance IDs
INSTANCE_IDS=()

for NAME in "${VMS[@]}"; do
  INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$NAME" "Name=instance-state-name,Values=running,stopped" \
    --query "Reservations[*].Instances[*].InstanceId" --output text)

  if [ -n "$INSTANCE_ID" ]; then
    echo "Finalizando $NAME com ID $INSTANCE_ID"
    aws ec2 terminate-instances --instance-ids "$INSTANCE_ID"
    INSTANCE_IDS+=($INSTANCE_ID)
  else
    echo "Instância $NAME não encontrada ou já terminada"
  fi
done

# Aguardar finalização de TODAS as instâncias coletadas
if [ ${#INSTANCE_IDS[@]} -gt 0 ]; then
  echo "Aguardando término das instâncias..."
  aws ec2 wait instance-terminated --instance-ids "${INSTANCE_IDS[@]}"
  echo "Instâncias finalizadas com sucesso"
else
  echo "Nenhuma instância para aguardar término"
fi

# Deletar security group com verificação
SG_ID=$(aws ec2 describe-security-groups \
  --group-names "$SG_NAME" \
  --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null)

if [ -n "$SG_ID" ]; then
  echo "Aguardando liberação do Security Group..."
  sleep 10  # pequena pausa pra garantir liberação
  aws ec2 delete-security-group --group-id "$SG_ID"
  echo "Security group removido com sucesso"
else
  echo "Security group $SG_NAME não encontrado ou já removido"
fi

# Deletar chave remota e local
aws ec2 delete-key-pair --key-name "$KEY_NAME"
rm -f "$KEY_NAME.pem"
echo "Keypair e arquivo local removidos"