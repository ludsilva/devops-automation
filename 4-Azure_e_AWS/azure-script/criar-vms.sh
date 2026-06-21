#!/bin/bash

# shellcheck disable=SC1091
source .env

criar_vm() {
  local NOME_VM=$1
  echo "Criando VM: $NOME_VM"

  az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$NOME_VM" \
    --image Ubuntu2204 \
    --size Standard_D2s_v7 \
    --admin-username azureuser \
    --admin-password "$PASSWORD" \
    --authentication-type password \
    --location "$LOCATION" \
    --no-wait
}

VMS=(
  vm01
  vm02
)

for nome in "${VMS[@]}"; do
  criar_vm "$nome"
done

echo "Criação em lote iniciada. Aguarde as VMs serem provisionadas."