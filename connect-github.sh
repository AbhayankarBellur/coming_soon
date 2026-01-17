#!/bin/bash

# Connect GitHub Repository to AWS Amplify App
# Requires GitHub Personal Access Token

set -e

APP_ID="d30r1ggpcrw7ge"
REGION="ap-south-1"
REPO_URL="https://github.com/AbhayankarBellur/coming_soon.git"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "📝 GitHub Personal Access Token Required"
    echo "========================================"
    echo ""
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Click 'Generate new token' → 'Generate new token (classic)'"
    echo "3. Name: 'AWS Amplify Deployment'"
    echo "4. Select scope: 'repo' (Full control of private repositories)"
    echo "5. Click 'Generate token'"
    echo "6. Copy the token"
    echo ""
    read -sp "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
    echo ""
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GitHub token is required"
    exit 1
fi

echo "🔗 Connecting GitHub repository..."
echo "App ID: $APP_ID"
echo "Repository: $REPO_URL"
echo ""

# Note: AWS Amplify CLI doesn't support updating repository after app creation
# We need to delete and recreate the app with repository connection
echo "⚠️  Note: AWS Amplify CLI requires repository connection during app creation."
echo "   We need to recreate the app with repository connection."
echo ""
read -p "Delete current app and recreate with GitHub connection? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled. Use AWS Console to connect repository manually."
    exit 0
fi

echo "🗑️  Deleting current app..."
aws amplify delete-app --app-id "$APP_ID" --region "$REGION" > /dev/null
echo "✅ App deleted"

echo ""
echo "📦 Creating app with GitHub repository..."
APP_RESULT=$(aws amplify create-app \
    --name coming-soon-warmpawz \
    --repository "$REPO_URL" \
    --access-token "$GITHUB_TOKEN" \
    --platform WEB \
    --region "$REGION" \
    --enable-branch-auto-build \
    2>&1)

if [ $? -ne 0 ]; then
    echo "❌ Failed to create app:"
    echo "$APP_RESULT"
    exit 1
fi

NEW_APP_ID=$(echo "$APP_RESULT" | grep -o '"appId": "[^"]*' | cut -d'"' -f4)
echo "✅ App created with repository: $NEW_APP_ID"

echo ""
echo "🚀 Deployment will start automatically..."
echo "   Monitor: aws amplify list-jobs --app-id $NEW_APP_ID --branch-name main --region $REGION"
