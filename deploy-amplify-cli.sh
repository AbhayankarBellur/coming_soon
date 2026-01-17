#!/bin/bash

# AWS Amplify CLI Deployment Script
# Deploys coming soon page to AWS Amplify with GitHub repository connection

set -e

REGION="ap-south-1"
APP_NAME="coming-soon-warmpawz"
REPO_URL="https://github.com/AbhayankarBellur/coming_soon.git"
BRANCH_NAME="main"
DOMAIN_NAME="warmpawz.com"

echo "🚀 AWS Amplify CLI Deployment"
echo "=============================="
echo ""
echo "Region: $REGION"
echo "App Name: $APP_NAME"
echo "Repository: $REPO_URL"
echo "Branch: $BRANCH_NAME"
echo "Domain: $DOMAIN_NAME"
echo ""

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first."
    exit 1
fi

# Check AWS credentials
echo "📋 Checking AWS credentials..."
if ! aws sts get-caller-identity --region $REGION &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run 'aws configure'"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "✅ AWS Account: $ACCOUNT_ID"
echo ""

# Check for existing app
echo "🔍 Checking for existing app..."
EXISTING_APP=$(aws amplify list-apps --region $REGION --query "apps[?name=='$APP_NAME'].appId" --output text 2>/dev/null || echo "")

if [ ! -z "$EXISTING_APP" ]; then
    echo "⚠️  App '$APP_NAME' already exists with ID: $EXISTING_APP"
    read -p "Delete and recreate? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Deleting existing app..."
        aws amplify delete-app --app-id "$EXISTING_APP" --region $REGION &> /dev/null
        echo "✅ App deleted"
    else
        APP_ID=$EXISTING_APP
        echo "Using existing app: $APP_ID"
    fi
fi

# Get GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo ""
    echo "📝 GitHub Access Token Required"
    echo "================================"
    echo "To connect the GitHub repository, we need a Personal Access Token."
    echo ""
    echo "Create one at: https://github.com/settings/tokens"
    echo "Required scopes: 'repo' (Full control of private repositories)"
    echo ""
    read -sp "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
    echo ""
    
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "❌ GitHub token is required. Exiting."
        exit 1
    fi
fi

# Create app with repository
if [ -z "$APP_ID" ]; then
    echo "📦 Creating Amplify app with GitHub repository..."
    APP_RESULT=$(aws amplify create-app \
        --name "$APP_NAME" \
        --repository "$REPO_URL" \
        --access-token "$GITHUB_TOKEN" \
        --platform WEB \
        --region $REGION \
        --enable-branch-auto-build \
        --environment-variables _LIVE_PACKAGE_UPDATES="[{\"pkg\":\"@aws-amplify/cli\",\"type\":\"npm\",\"version\":\"latest\"}]" \
        2>&1)
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create app:"
        echo "$APP_RESULT"
        exit 1
    fi
    
    APP_ID=$(echo "$APP_RESULT" | grep -o '"appId": "[^"]*' | cut -d'"' -f4)
    echo "✅ App created: $APP_ID"
else
    echo "✅ Using existing app: $APP_ID"
fi

# Wait a moment for app to be ready
sleep 3

# Check branch
echo ""
echo "🔍 Checking branch '$BRANCH_NAME'..."
BRANCH_EXISTS=$(aws amplify get-branch --app-id "$APP_ID" --branch-name "$BRANCH_NAME" --region $REGION 2>&1 || echo "not found")

if echo "$BRANCH_EXISTS" | grep -q "not found\|does not exist"; then
    echo "📝 Creating branch '$BRANCH_NAME'..."
    aws amplify create-branch \
        --app-id "$APP_ID" \
        --branch-name "$BRANCH_NAME" \
        --region $REGION \
        --enable-auto-build \
        > /dev/null
    echo "✅ Branch created"
else
    echo "✅ Branch exists"
fi

# Start deployment
echo ""
echo "🚀 Starting deployment..."
JOB_RESULT=$(aws amplify start-job \
    --app-id "$APP_ID" \
    --branch-name "$BRANCH_NAME" \
    --job-type RELEASE \
    --region $REGION \
    2>&1)

if [ $? -eq 0 ]; then
    JOB_ID=$(echo "$JOB_RESULT" | grep -o '"jobSummary": {[^}]*"jobId": "[^"]*' | grep -o '"jobId": "[^"]*' | cut -d'"' -f4 || echo "")
    echo "✅ Deployment started"
    if [ ! -z "$JOB_ID" ]; then
        echo "   Job ID: $JOB_ID"
    fi
else
    echo "⚠️  Could not start job (might already be running):"
    echo "$JOB_RESULT"
fi

# Get app URL
echo ""
echo "📱 Getting app URL..."
APP_INFO=$(aws amplify get-app --app-id "$APP_ID" --region $REGION 2>&1)
DEFAULT_DOMAIN=$(echo "$APP_INFO" | grep -o '"defaultDomain": "[^"]*' | cut -d'"' -f4 || echo "")

if [ ! -z "$DEFAULT_DOMAIN" ]; then
    echo "✅ App URL: https://$BRANCH_NAME.$DEFAULT_DOMAIN"
fi

# Configure custom domain
echo ""
echo "🌐 Configuring custom domain..."
read -p "Configure custom domain '$DOMAIN_NAME' now? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📝 Creating domain association..."
    DOMAIN_RESULT=$(aws amplify create-domain-association \
        --app-id "$APP_ID" \
        --domain-name "$DOMAIN_NAME" \
        --sub-domain-settings prefix=www,branchName=$BRANCH_NAME \
        --enable-auto-sub-domain false \
        --region $REGION \
        2>&1)
    
    if [ $? -eq 0 ]; then
        echo "✅ Domain association created"
        echo ""
        echo "📋 DNS Records to add at your domain registrar:"
        echo "$DOMAIN_RESULT" | grep -A 10 "dnsRecords" || echo "Check AWS Console for DNS records"
        echo ""
        echo "⚠️  Add the CNAME record for 'www' subdomain at your DNS provider"
        echo "   This will enable SSL certificate provisioning"
    else
        echo "⚠️  Domain might already be associated or error occurred:"
        echo "$DOMAIN_RESULT"
    fi
fi

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "📊 Monitor deployment:"
echo "   aws amplify list-jobs --app-id $APP_ID --branch-name $BRANCH_NAME --region $REGION"
echo ""
echo "🌐 App URL: https://$BRANCH_NAME.$DEFAULT_DOMAIN"
echo ""
echo "📝 Next steps:"
echo "   1. Wait for build to complete (2-5 minutes)"
echo "   2. Add DNS records for custom domain (if configured)"
echo "   3. Wait for SSL certificate provisioning (30-60 minutes)"
echo "   4. Test: https://www.$DOMAIN_NAME"
echo ""
