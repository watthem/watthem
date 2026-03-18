# Deployment Guide

This repository is not a Wrangler or Cloudflare Pages frontend.

It is the `watthem` GitHub profile / metadata repo, so the effective deployment is a push to the default branch that GitHub renders automatically.

## Current Publish Path

1. Commit the repo on the default branch (`master`)
2. Push to `origin/master`
3. Verify the rendered profile page on GitHub

## One-Command Helper

```bash
./DEPLOY.sh --dry-run
./DEPLOY.sh --push
```

## Notes

- No `wrangler` config is expected here
- No build output is expected here
- `scripts/deploy.sh` forwards to `DEPLOY.sh`
