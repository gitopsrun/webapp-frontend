# Webapp Frontend

Source staging:

```bash
tk create source git webapp-frontend \
  --url=https://github.com/gitopsrun/webapp-frontend \
  --branch=staging \
  --interval=1m
```

Frontend staging:

```bash
tk create kustomization webapp-frontend \
  --depends-on=webapp-staging \
  --sa-name=reconciler \
  --sa-namespace=staging \
  --source=webapp-frontend \
  --path="./deploy/overlays/staging" \
  --prune=true \
  --validate=client \
  --interval=30m
```

