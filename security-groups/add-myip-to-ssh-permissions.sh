#!/bin/bash
# Seu endereço IP atual
your_ip=$(curl http://meuip.com/api/meuip.php)
echo "Seu ip atual é: $your_ip"

# Endereço IP adicional (32 bits)
additional_ip="X.X.X.X/32"

# Seu ID de grupo de segurança
GROUP_ID="sg-security_group_id"

RULES=$(aws ec2 describe-security-groups --group-ids $GROUP_ID --query "SecurityGroups[].IpPermissions[?ToPort==\`22\`]")

# Loop through each rule and revoke it


echo $RULES | jq -c '.[][0]' | while read -r RULE; do
   i=0
   echo $RULE | jq -r ".IpRanges[$i].CidrIp" | while read -r CIDR; do
       echo "Revoking rule for $CIDR"
       aws ec2 revoke-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr "$CIDR"
       echo "Regra revogada para $CIDR"
       i=$((i+1));
       echo "índice atual: $i"
   done
done

aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr "$your_ip/32"
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr "$additional_ip"

echo "Regras de entrada modificadas no grupo de segurança $security_group_id."