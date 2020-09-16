# Docker Action

Build and push a docker image to GitHub's container registry.

This action is based on sensible defaults.

## Usage

```yaml
- uses: pedro-gutierrez/docker-action@v5
  name: Build and Push
  with:
    password: ${{ secrets.DOCKER_PASSWORD }}
    tag: latest
```
