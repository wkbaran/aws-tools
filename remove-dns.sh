#!/bin/bash
# Simple script to add a DNS record for a subdomain
# Usage: ./add-dns.sh subdomain

# Load environment variables from .env file
if [ -f ./.env ]; then
  . ./.env
else
  echo "Warning: .env file not found. Using default values."
fi

# Get subdomain name from command line
SUBDOMAIN=$1
PUBLIC_IP=$2

if [ -z "$PUBLIC_IP" ]; then
  echo "Error: Subdomain name required"
  echo "Usage: ./remove-dns.sh subdomain"
  exit 1
fi

echo "Removing DNS record for ${SUBDOMAIN}.${DOMAIN} pointing to ${PUBLIC_IP}"

# Create change batch JSON
cat > /tmp/change-batch.json << EOF
{
  "Comment": "Removing A record for ${SUBDOMAIN}.${DOMAIN}",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "${SUBDOMAIN}.${DOMAIN}",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${PUBLIC_IP}"
          }
        ]
      }
    }
  ]
}
EOF

# Apply the change
echo aws route53 change-resource-record-sets \
  --hosted-zone-id ${ZONE_ID} \
  --change-batch file:///tmp/change-batch.json
aws route53 change-resource-record-sets \
  --hosted-zone-id ${ZONE_ID} \
  --change-batch file:///tmp/change-batch.json

if [ $? -eq 0 ]; then
    echo "Success: DNS record was successfully deleted."
else
    echo "Error: Failed to delete DNS record. Exit code: $?"
fi
