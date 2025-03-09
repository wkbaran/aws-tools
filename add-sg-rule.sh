# Add a rule to an existing security group
REGION=$1      # AWS region filter (e.g., us-west-2)
SG_ID=$2       # Security Group ID (e.g., sg-0abcd1234)
PORT=$3        # Port to allow (e.g., 443 for HTTPS)
CIDR=$4
DESC=$5

# So to get all the Cloudfront IPs for the us-west-* regions, you'd:
#   for i in $(./get-cloudfront-ips.sh us-west-); do
#     ./add-sg-rule.sh us-west-2 sg-00d686c7073b0e555 80 $i 
#   done
#

#aws ec2 authorize-security-group-ingress \
#        --group-id "$SG_ID" \
#        --protocol tcp \
#        --port "$PORT" \
#        --cidr "$CIDR" \
#        --region us-west-2 \
#        --tag-specifications "ResourceType=security-group-rule,Tags=[{Key=Description,Value=\"$DESC\"}]"

aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --region $REGION --ip-permissions "[
        {
            \"IpProtocol\": \"tcp\",
            \"FromPort\": $PORT,
            \"ToPort\": $PORT,
            \"IpRanges\": [
                {
                    \"CidrIp\": \"$CIDR\",
                    \"Description\": \"$DESC\"
                }
            ]
        }
    ]"
