#!/bin/sh
REGION=$1

curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | \
jq -r --arg region "$REGION" '.prefixes[] | select(.service=="CLOUDFRONT" and (.region | test("^\($region)"))) | .ip_prefix'
