#!/bin/bash

TAG="tag de instancia desejada"
VALUE="valor da tag"

# Busca as informações da instância com a tag especificada
instance_info=$(aws ec2 describe-instances --filters "Name=tag:$TAG,Values=$VALUE" --query "Reservations[].Instances[].[PublicIpAddress]" --output text)

# Verifica se há instâncias em execução com a tag especificada
if [ -z "$instance_info" ]; then
    echo "Nenhuma instância encontrada com a tag '$TAG=$VALUE'."
else
    # Extrai e imprime o endereço IP da instância
    echo "Endereço IP da instância em execução com a tag '$TAG=$VALUE': $instance_info"
fi