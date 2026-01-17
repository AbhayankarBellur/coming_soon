# Quick Start: Deploy to AWS Amplify

## Prerequisites Checklist
- [ ] AWS Account with Amplify access
- [ ] GitHub repository access: https://github.com/AbhayankarBellur/coming_soon.git
- [ ] Domain `warmpawz.com` registered
- [ ] DNS management access for warmpawz.com

## Deployment Steps

### 1. Connect Repository to AWS Amplify (5 minutes)

1. Go to https://console.aws.amazon.com/amplify/
2. Click **"New app"** → **"Host web app"**
3. Select **"GitHub"** and authorize
4. Choose repository: **`AbhayankarBellur/coming_soon`**
5. Branch: **`main`**
6. Build settings: Auto-detected from `amplify.yml` ✅
7. Click **"Save and deploy"**

### 2. Configure Custom Domain (10 minutes)

1. In Amplify app → **"Domain management"** → **"Add domain"**
2. Enter: **`warmpawz.com`**
3. Add subdomain: **`www`** → Select branch **`main`**
4. Copy the DNS records provided by Amplify

### 3. Update DNS Records (5 minutes)

At your domain registrar (GoDaddy, Namecheap, Route53, etc.):

**Add CNAME Record:**
```
Type: CNAME
Name: www
Value: [Amplify-provided domain, e.g., d1234567890.cloudfront.net]
TTL: 3600
```

**For apex domain (optional):**
- Use ALIAS or A record as provided by Amplify

### 4. Wait for Propagation (15 minutes - 48 hours)

- DNS propagation: Usually 15-60 minutes
- SSL certificate: Auto-provisioned by AWS (30-60 minutes after DNS)
- Check status: Visit `https://www.warmpawz.com`

## Verification

✅ Build completes successfully in Amplify Console
✅ App loads at Amplify URL (e.g., `https://main.xxxxx.amplifyapp.com`)
✅ Custom domain works: `https://www.warmpawz.com`
✅ SSL certificate is active (green padlock)

## Troubleshooting

**Build fails?**
- Check build logs in Amplify Console
- Verify `amplify.yml` exists in repository root

**Domain not working?**
- Verify DNS records are correct
- Check DNS propagation: https://www.whatsmydns.net/
- Wait up to 48 hours for full propagation

**SSL not working?**
- Ensure DNS is fully propagated
- Check AWS Certificate Manager for certificate status
- Wait 30-60 minutes after DNS is correct

## Support Resources

- AWS Amplify Docs: https://docs.aws.amazon.com/amplify/
- Custom Domains: https://docs.aws.amazon.com/amplify/latest/userguide/custom-domains.html
