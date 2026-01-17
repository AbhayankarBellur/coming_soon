# Step-by-Step AWS Amplify Deployment Guide

## 🎯 Goal
Deploy the coming soon page to AWS Amplify and configure www.warmpawz.com

## ⏱️ Estimated Time: 20-30 minutes

---

## Step 1: Create Amplify App (5 minutes)

### 1.1 Open AWS Amplify Console
- Go to: **https://console.aws.amazon.com/amplify/**
- Make sure you're in the correct AWS region (e.g., us-east-1)

### 1.2 Create New App
1. Click the **"New app"** button (top right)
2. Select **"Host web app"**

### 1.3 Connect GitHub Repository
1. Under "Get started", select **"GitHub"**
2. Click **"Authorize use of GitHub"** (if not already authorized)
3. You'll be redirected to GitHub to authorize AWS Amplify
4. Click **"Authorize aws-amplify-console"**
5. You'll be redirected back to AWS Console

### 1.4 Select Repository
1. In the repository dropdown, find and select: **`AbhayankarBellur/coming_soon`**
2. Select branch: **`main`**
3. Click **"Next"**

### 1.5 Configure Build Settings
- AWS Amplify should **auto-detect** the build settings from `amplify.yml`
- Verify:
  - **App name**: `coming-soon-warmpawz` (or your preferred name)
  - **Build settings**: Should show `amplify.yml` detected ✅
  - **Environment variables**: None needed for this project
- Click **"Next"**

### 1.6 Review and Deploy
1. Review all settings
2. Click **"Save and deploy"**
3. **Wait for build to complete** (2-5 minutes)
   - You'll see build progress in real-time
   - Build should complete successfully ✅

### 1.7 Note Your App URL
- After deployment, you'll see a URL like: `https://main.xxxxx.amplifyapp.com`
- **Save this URL** - you'll need it for domain configuration

---

## Step 2: Configure Custom Domain (10 minutes)

### 2.1 Navigate to Domain Management
1. In your Amplify app dashboard, click **"Domain management"** in the left sidebar
2. Click **"Add domain"**

### 2.2 Add Your Domain
1. Enter your domain: **`warmpawz.com`**
2. Click **"Configure domain"**

### 2.3 Configure Subdomain
1. Under "Subdomains", you'll see `www` listed
2. Click on the `www` row
3. In the dropdown, select your branch: **`main`**
4. Click **"Save"**

### 2.4 Get DNS Records
- AWS Amplify will show you DNS records to add
- You'll see something like:
  ```
  Type: CNAME
  Name: www
  Value: d1234567890.cloudfront.net
  ```
- **Copy these records** - you'll need them in the next step

### 2.5 For Apex Domain (Optional)
- If you want `warmpawz.com` (without www) to work:
  - AWS will provide ALIAS or A records
  - Follow the same process for the apex domain

---

## Step 3: Update DNS Records (5 minutes)

### 3.1 Access Your Domain Registrar
- Log in to where you registered `warmpawz.com`
- Common registrars: GoDaddy, Namecheap, Route53, Google Domains, etc.
- Navigate to **DNS Management** or **DNS Settings**

### 3.2 Add CNAME Record
1. Find the option to **"Add Record"** or **"Add DNS Record"**
2. Create a new CNAME record:
   - **Type**: `CNAME`
   - **Name/Host**: `www`
   - **Value/Target**: [The value from Step 2.4, e.g., `d1234567890.cloudfront.net`]
   - **TTL**: `3600` (or leave default)
3. Click **"Save"** or **"Add Record"**

### 3.3 Verify Record Added
- You should see the new CNAME record in your DNS list
- It may take a few minutes to appear

---

## Step 4: Wait for DNS Propagation (15 minutes - 48 hours)

### 4.1 Check DNS Propagation
- DNS changes typically propagate in **15-60 minutes**
- Can take up to **48 hours** in rare cases
- Check status: https://www.whatsmydns.net/#CNAME/www.warmpawz.com

### 4.2 SSL Certificate
- AWS Amplify **automatically provisions** SSL certificates via AWS Certificate Manager
- Certificate is issued **30-60 minutes** after DNS is properly configured
- You can check status in Amplify Console → Domain management

### 4.3 Test Your Domain
- Once DNS propagates, visit: **https://www.warmpawz.com**
- You should see:
  - ✅ Page loads correctly
  - ✅ SSL certificate active (green padlock)
  - ✅ Coming soon page displays

---

## Step 5: Verification Checklist

Use this checklist to verify everything is working:

- [ ] Build completed successfully in Amplify Console
- [ ] App loads at Amplify-provided URL (e.g., `https://main.xxxxx.amplifyapp.com`)
- [ ] DNS records added at domain registrar
- [ ] DNS propagated (check with whatsmydns.net)
- [ ] SSL certificate issued (check in Amplify Console)
- [ ] `https://www.warmpawz.com` loads correctly
- [ ] Coming soon page displays on desktop
- [ ] Coming soon page displays on mobile
- [ ] Loading animation works correctly
- [ ] No console errors in browser

---

## 🆘 Troubleshooting

### Build Fails
**Symptoms**: Build shows errors in Amplify Console
**Solutions**:
- Check build logs in Amplify Console
- Verify `amplify.yml` exists in repository root
- Ensure all dependencies are in `package.json`
- Check that `npm ci` and `npm run build` work locally

### Domain Not Working
**Symptoms**: `www.warmpawz.com` doesn't load or shows DNS error
**Solutions**:
- Verify DNS records are correct at registrar
- Check DNS propagation: https://www.whatsmydns.net/
- Ensure CNAME value matches exactly what Amplify provided
- Wait up to 48 hours for full propagation
- Check TTL is not too high (3600 recommended)

### SSL Certificate Not Issued
**Symptoms**: HTTPS doesn't work or shows certificate error
**Solutions**:
- Ensure DNS is fully propagated first
- Verify DNS records are correct
- Check AWS Certificate Manager console
- Wait 30-60 minutes after DNS is correct
- Contact AWS Support if issues persist after 24 hours

### Page Not Loading
**Symptoms**: Domain works but page shows error
**Solutions**:
- Check Amplify build logs
- Verify build completed successfully
- Check browser console for errors
- Ensure `dist` folder contains all files
- Verify `index.html` exists in build output

---

## 📞 Support Resources

- **AWS Amplify Docs**: https://docs.aws.amazon.com/amplify/
- **Custom Domains Guide**: https://docs.aws.amazon.com/amplify/latest/userguide/custom-domains.html
- **AWS Support**: https://console.aws.amazon.com/support/

---

## ✅ Success Indicators

You'll know deployment is successful when:
1. ✅ Build completes without errors
2. ✅ App loads at Amplify URL
3. ✅ DNS records are added and propagated
4. ✅ SSL certificate is active
5. ✅ `https://www.warmpawz.com` loads the coming soon page
6. ✅ Page works on both desktop and mobile

---

**Ready to start?** Begin with Step 1 above! 🚀
