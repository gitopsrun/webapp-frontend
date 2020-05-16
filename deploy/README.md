# Webapp Frontend

## Staging 

Source:

```bash
tk create source git webapp-frontend \
  --url=https://github.com/gitopsrun/webapp-frontend \
  --branch=staging \
  --interval=1m
```

Deployment:

```bash
tk create kustomization webapp-frontend \
  --depends-on=webapp \
  --sa-name=reconciler \
  --sa-namespace=frontend \
  --source=webapp-frontend \
  --path="./deploy/overlays/staging" \
  --prune=true \
  --validate=client \
  --interval=30m
```

## Production 

Source:

```bash
tk create source git webapp-frontend \
  --url=https://github.com/gitopsrun/webapp-frontend \
  --tag-semver=">0.0.1 <1.0.0" \
  --interval=1m
```

Deployment:

```bash
tk create kustomization webapp-frontend \
  --depends-on=webapp \
  --sa-name=reconciler \
  --sa-namespace=frontend \
  --source=webapp-frontend \
  --path="./deploy/overlays/production" \
  --prune=true \
  --validate=client \
  --interval=30m
```

## Local

```bash
make deploy
```