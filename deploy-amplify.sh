#!/bin/bash

# AWS Amplify Deployment Script for Coming Soon Page
# This script helps deploy the app to AWS Amplify

set -e

echo "🚀 AWS Amplify Deployment Script"
echo "================================"
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

# App configuration
APP_NAME="coming-soon-warmpawz"
REPO_URL="https://github.com/AbhayankarBellur/coming_soon.git"
BRANCH_NAME="main"

echo "📦 App Configuration:"
echo "   Name: $APP_NAME"
echo "   Repository: $REPO_URL"
echo "   Branch: $BRANCH_NAME"
echo ""

# Check if app already exists
echo "🔍 Checking for existing Amplify apps..."
EXISTING_APP=$(aws amplify list-apps --query "apps[?name=='$APP_NAME'].appId" --output text 2>/dev/null || echo "")

if [ ! -z "$EXISTING_APP" ]; then
    echo "⚠️  App '$APP_NAME' already exists with ID: $EXISTING_APP"
    read -p "Do you want to continue with deployment? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    APP_ID=$EXISTING_APP
else
    echo "📝 Note: Creating Amplify apps via CLI requires GitHub OAuth setup."
    echo "   For easiest deployment, use AWS Console:"
    echo "   1. Go to https://console.aws.amazon.com/amplify/"
    echo "   2. Click 'New app' → 'Host web app'"
    echo "   3. Select 'GitHub' and authorize"
    echo "   4. Choose repository: AbhayankarBellur/coming_soon"
    echo "   5. Branch: main"
    echo ""
    echo "   Alternatively, if you have GitHub OAuth token, we can proceed via CLI."
    echo ""
    read -p "Do you want to proceed with Console instructions? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    echo ""
    echo "✅ Please complete the deployment in AWS Console."
    echo "   After deployment, run this script again to configure the domain."
    exit 0
fi

echo ""
echo "✅ Deployment setup complete!"
echo ""
echo "Next steps:"
echo "1. Complete app creation in AWS Amplify Console"
echo "2. Wait for initial deployment to complete"
echo "3. Configure custom domain: www.warmpawz.com"
echo ""
echo "See DEPLOYMENT_QUICK_START.md for detailed instructions."
