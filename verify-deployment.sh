#!/bin/bash

# Verification Script for AWS Amplify Deployment
# This script helps verify your deployment status

set -e

echo "🔍 AWS Amplify Deployment Verification"
echo "======================================"
echo ""

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first."
    exit 1
fi

# Check AWS credentials
echo "📋 Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run 'aws configure'"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "✅ AWS Account: $ACCOUNT_ID"
echo ""

# List Amplify apps
echo "📦 Checking Amplify apps..."
APPS=$(aws amplify list-apps --query 'apps[*].[name,appId,defaultDomain]' --output table 2>/dev/null || echo "")

if [ -z "$APPS" ] || [ "$APPS" == "None" ]; then
    echo "⚠️  No Amplify apps found."
    echo ""
    echo "Please create an app first:"
    echo "1. Go to https://console.aws.amazon.com/amplify/"
    echo "2. Follow the deployment guide in STEP_BY_STEP_DEPLOYMENT.md"
    exit 1
fi

echo "$APPS"
echo ""

# Check domain configuration
echo "🌐 Checking domain configurations..."
read -p "Enter your Amplify App ID (or press Enter to skip): " APP_ID

if [ ! -z "$APP_ID" ]; then
    echo ""
    echo "Checking branches for app: $APP_ID"
    BRANCHES=$(aws amplify list-branches --app-id "$APP_ID" --query 'branches[*].[branchName,displayName]' --output table 2>/dev/null || echo "Error fetching branches")
    echo "$BRANCHES"
    echo ""
    
    echo "Checking domain associations..."
    DOMAINS=$(aws amplify list-domain-associations --app-id "$APP_ID" --query 'domainAssociations[*].[domainName,enableAutoSubDomain]' --output table 2>/dev/null || echo "No domains configured")
    echo "$DOMAINS"
    echo ""
fi

# Test DNS
echo "🔍 Testing DNS for www.warmpawz.com..."
if command -v dig &> /dev/null; then
    DNS_RESULT=$(dig +short www.warmpawz.com CNAME 2>/dev/null || echo "DNS lookup failed")
    if [ ! -z "$DNS_RESULT" ] && [ "$DNS_RESULT" != "DNS lookup failed" ]; then
        echo "✅ DNS CNAME found: $DNS_RESULT"
    else
        echo "⚠️  DNS CNAME not found or not propagated yet"
    fi
else
    echo "ℹ️  'dig' command not available. Check DNS manually at: https://www.whatsmydns.net/#CNAME/www.warmpawz.com"
fi

echo ""
echo "✅ Verification complete!"
echo ""
echo "Next steps:"
echo "- If app is deployed, configure custom domain in Amplify Console"
echo "- If domain is configured, wait for DNS propagation"
echo "- Test at: https://www.warmpawz.com"
