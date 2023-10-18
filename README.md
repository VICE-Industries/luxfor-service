# fastapi-luxafor

FastAPI service to control a [Luxafor](https://luxafor.de) USB Device.

The service is used in our edge demonstrator to display states.

## Build

```
docker buildx build --platform linux/amd64 -t ghcr.io/vice-industries/fastapi-luxafor:latest .
docker push ghcr.io/vice-industries/fastapi-luxafor:latest
```
