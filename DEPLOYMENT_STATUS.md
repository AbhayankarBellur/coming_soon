# AWS Amplify Deployment Status - CLI Deployment

## ✅ Completed Steps

1. ✅ **App Created**: `d30r1ggpcrw7ge` in region `ap-south-1`
2. ✅ **Branch Created**: `main` branch with auto-build enabled
3. ✅ **Domain Configured**: `warmpawz.com` with `www` subdomain

## ⏳ Pending Steps

### 1. Connect GitHub Repository

**Current Status**: App created but not connected to GitHub repository yet.

**To Connect** (requires GitHub Personal Access Token):

```bash
cd coming_soon
./connect-github.sh
```

Or manually:

1. Get GitHub token: https://github.com/settings/tokens
   - Scope needed: `repo` (Full control of private repositories)
2. Run:
```bash
# Delete current app and recreate with GitHub connection
aws amplify delete-app --app-id d30r1ggpcrw7ge --region ap-south-1

aws amplify create-app \
  --name coming-soon-warmpawz \
  --repository https://github.com/AbhayankarBellur/coming_soon.git \
  --access-token YOUR_GITHUB_TOKEN \
  --platform WEB \
  --region ap-south-1 \
  --enable-branch-auto-build
```

Then recreate domain association:
```bash
aws amplify create-domain-association \
  --app-id NEW_APP_ID \
  --domain-name warmpawz.com \
  --sub-domain-settings prefix=www,branchName=main \
  --no-enable-auto-sub-domain \
  --region ap-south-1
```

### 2. Add DNS Records

**DNS Record to Add at Your Domain Registrar:**

```
Type: CNAME
Name: www
Value: d2vvgitjqz9r5s.cloudfront.net
TTL: 3600
```

**Where to Add:**
- Log in to your domain registrar (where you registered warmpawz.com)
- Go to DNS Management / DNS Settings
- Add the CNAME record above

**After adding DNS:**
- Wait 15-60 minutes for DNS propagation
- SSL certificate will auto-provision (30-60 minutes after DNS)
- Test: https://www.warmpawz.com

## 📊 Current App Information

- **App ID**: `d30r1ggpcrw7ge`
- **Region**: `ap-south-1`
- **Default Domain**: `d30r1ggpcrw7ge.amplifyapp.com`
- **Branch**: `main`
- **Custom Domain**: `warmpawz.com` (www subdomain)

## 🔍 Useful Commands

**Check app status:**
```bash
aws amplify get-app --app-id d30r1ggpcrw7ge --region ap-south-1
```

**List branches:**
```bash
aws amplify list-branches --app-id d30r1ggpcrw7ge --region ap-south-1
```

**Check domain status:**
```bash
aws amplify get-domain-association --app-id d30r1ggpcrw7ge --domain-name warmpawz.com --region ap-south-1
```

**Start deployment (after GitHub connection):**
```bash
aws amplify start-job \
  --app-id d30r1ggpcrw7ge \
  --branch-name main \
  --job-type RELEASE \
  --region ap-south-1
```

**List jobs:**
```bash
aws amplify list-jobs --app-id d30r1ggpcrw7ge --branch-name main --region ap-south-1
```

## 🚀 Next Steps

1. **Get GitHub Personal Access Token**
   - Go to: https://github.com/settings/tokens
   - Generate new token with `repo` scope
   - Run `./connect-github.sh` or use manual commands above

2. **Add DNS Record**
   - Add CNAME record: `www` → `d2vvgitjqz9r5s.cloudfront.net`
   - Wait for propagation

3. **Verify Deployment**
   - Check build status in Amplify Console or via CLI
   - Test: https://www.warmpawz.com (after DNS propagates)

## 📝 Notes

- GitHub repository connection requires OAuth token (one-time setup)
- After connecting GitHub, deployments will be automatic on push to `main` branch
- SSL certificate is automatically provisioned by AWS Amplify
- DNS propagation can take 15-60 minutes (up to 48 hours in rare cases)
