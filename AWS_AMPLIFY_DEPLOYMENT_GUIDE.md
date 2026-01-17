# AWS Amplify Deployment Guide for Coming Soon Page

This guide will help you deploy the coming soon page to AWS Amplify and configure the custom domain `www.warmpawz.com`.

## Prerequisites

1. AWS Account with appropriate permissions
2. Access to AWS Amplify Console
3. Domain `warmpawz.com` registered and DNS access
4. GitHub repository: https://github.com/AbhayankarBellur/coming_soon.git

## Step 1: Deploy to AWS Amplify

### Option A: Using AWS Amplify Console (Recommended)

1. **Sign in to AWS Amplify Console**
   - Go to https://console.aws.amazon.com/amplify/
   - Sign in with your AWS account

2. **Create a New App**
   - Click "New app" → "Host web app"
   - Select "GitHub" as your source
   - Authorize AWS Amplify to access your GitHub account if prompted
   - Select the repository: `AbhayankarBellur/coming_soon`
   - Select the branch: `main`
   - Click "Next"

3. **Configure Build Settings**
   - AWS Amplify should auto-detect the build settings from `amplify.yml`
   - Verify the build settings:
     - Build command: `npm run build`
     - Output directory: `dist`
   - Click "Next"

4. **Review and Deploy**
   - Review the settings
   - Click "Save and deploy"
   - Wait for the build to complete (usually 2-5 minutes)

### Option B: Using AWS CLI

```bash
# Install AWS CLI if not already installed
# Configure AWS credentials
aws configure

# Create Amplify app
aws amplify create-app \
  --name coming-soon-warmpawz \
  --repository https://github.com/AbhayankarBellur/coming_soon.git \
  --platform WEB \
  --environment-variables BUILD_COMMAND="npm run build",OUTPUT_DIR="dist"

# Create branch
aws amplify create-branch \
  --app-id <APP_ID> \
  --branch-name main

# Start deployment
aws amplify start-job \
  --app-id <APP_ID> \
  --branch-name main \
  --job-type RELEASE
```

## Step 2: Configure Custom Domain (www.warmpawz.com)

### In AWS Amplify Console:

1. **Navigate to Domain Management**
   - In your Amplify app, go to "Domain management" in the left sidebar
   - Click "Add domain"

2. **Add Your Domain**
   - Enter: `warmpawz.com`
   - Click "Configure domain"

3. **Configure Subdomain**
   - Select `www` subdomain
   - Choose your Amplify app branch (usually `main`)
   - Click "Save"

4. **Get DNS Records**
   - AWS Amplify will provide you with DNS records (CNAME or A records)
   - Copy these records

### Configure DNS at Your Domain Registrar:

1. **Access Your Domain DNS Settings**
   - Log in to your domain registrar (where you registered warmpawz.com)
   - Navigate to DNS management

2. **Add DNS Records**
   - Add the CNAME record provided by AWS Amplify:
     - Type: `CNAME`
     - Name: `www`
     - Value: The Amplify domain provided (e.g., `d1234567890.cloudfront.net`)
     - TTL: 3600 (or default)

   - For the apex domain (warmpawz.com), you may need:
     - Type: `A` or `ALIAS` (depending on your registrar)
     - Name: `@` or leave blank
     - Value: The IP address or ALIAS target provided by Amplify

3. **Wait for DNS Propagation**
   - DNS changes can take 24-48 hours to propagate
   - You can check propagation status using tools like:
     - https://www.whatsmydns.net/
     - `dig www.warmpawz.com` or `nslookup www.warmpawz.com`

4. **Verify SSL Certificate**
   - AWS Amplify automatically provisions SSL certificates via AWS Certificate Manager
   - The certificate will be issued once DNS is properly configured
   - This usually takes 30-60 minutes after DNS propagation

## Step 3: Verify Deployment

1. **Check Build Status**
   - In Amplify Console, verify the build completed successfully
   - Check for any build errors in the build logs

2. **Test the App**
   - Visit the Amplify-provided URL (e.g., `https://main.xxxxx.amplifyapp.com`)
   - Verify the coming soon page loads correctly

3. **Test Custom Domain**
   - Once DNS propagates, visit `https://www.warmpawz.com`
   - Verify SSL certificate is active (HTTPS works)
   - Test on mobile and desktop devices

## Troubleshooting

### Build Failures
- Check build logs in Amplify Console
- Verify `amplify.yml` is correct
- Ensure all dependencies are in `package.json`

### DNS Issues
- Verify DNS records are correctly configured
- Check DNS propagation status
- Ensure TTL is not too high (3600 seconds recommended)

### SSL Certificate Issues
- Wait for DNS to fully propagate
- Verify DNS records are correct
- Check AWS Certificate Manager for certificate status

### Custom Domain Not Working
- Verify DNS records point to correct Amplify domain
- Check that both `www.warmpawz.com` and `warmpawz.com` are configured
- Ensure SSL certificate is issued and active

## Additional Configuration

### Environment Variables (if needed)
If you need to add environment variables:
1. Go to App settings → Environment variables
2. Add any required variables
3. Redeploy the app

### Custom Headers (if needed)
You can add custom headers in `amplify.yml`:
```yaml
customHeaders:
  - pattern: '**/*'
    headers:
      - key: 'X-Content-Type-Options'
        value: 'nosniff'
      - key: 'X-Frame-Options'
        value: 'DENY'
```

## Support

For AWS Amplify documentation, visit:
- https://docs.aws.amazon.com/amplify/
- https://docs.aws.amazon.com/amplify/latest/userguide/custom-domains.html
