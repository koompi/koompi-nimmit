# Deploy Procedure

Deploy a project to Vercel, KConsole, or self-hosted.

## Vercel

### Prerequisites
- `vercel` CLI installed (`bun install -g vercel`)
- Authenticated (`vercel login`)
- GitHub repo created

### Steps

```bash
cd ~/workspace/<slug>/

# Create GitHub repo
gh repo create <slug> --public --source=. --push

# Deploy preview
vercel --yes

# If preview looks good, deploy to production
vercel --prod
```

### Output
- Preview URL: `https://<slug>-<hash>.vercel.app`
- Production URL: `https://<slug>.vercel.app`
- Custom domain: `vercel domains add <domain>`

## KConsole (KOOMPI Cloud)

### Prerequisites
- `kconsole` CLI installed
- Authenticated with KOOMPI Cloud
- Project name available

### Steps

```bash
cd ~/workspace/<slug>/

# Deploy to KConsole
kconsole deploy --name <slug> --region ap-southeast-1

# The CLI handles build + deploy
```

### Output
- URL: `https://<slug>.kconsole.app`

## Self-Hosted (Docker)

### Prerequisites
- Docker installed
- Domain configured with DNS

### Steps

```bash
cd ~/workspace/<slug>/

# Build Docker image
docker build -t <slug> .

# Run
docker run -d -p 3000:3000 --name <slug> \
  -e NEXT_PUBLIC_SUPABASE_URL=<url> \
  -e NEXT_PUBLIC_SUPABASE_ANON_KEY=<key> \
  -e DATABASE_URL=<direct-url> \
  <slug>
```

## Post-Deploy Checklist

- [ ] Homepage loads without errors
- [ ] Auth flow works (login/logout)
- [ ] Database queries return data
- [ ] Mobile responsive
- [ ] No console errors
- [ ] Screenshot sent to user
