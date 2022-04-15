# NOAuth Server

This repository hosts an OAuth authorization server which provides absolutely no security.
Its purpose is to enable development tests.

## Dependencies

- [Dart](https://www.dart.dev): Required to configure and run the mock server
- [Docker](https://www.docker.com): (Optional) Required to package and publish the mock server

## Run server via Dart VM

```
# Run server on default port 8080
dart bin/server.dart

# Run server on specific port
dart bin/server.dart 7777
```

## Usage

```
$ curl -i 'localhost:9876/authorize?redirect_uri=http://localhost:8080/bff/callback&state=12323'
HTTP/1.1 302 Found
location: http://localhost:8080/bff/callback?code=W7S4aFZ&state=12323
```

## Run server via Docker

```bash
# Build docker image
docker build . -t noauth

# Run in daemon mode
docker run -d -p 7777:8080 noauth

# Try request
curl localhost:7777/
```

## Development

### Generate routes

```
dart run build_runner build
```

## Maintenance

### Deploy to Cloud Run

```bash
gcloud init
gcloud run deploy
```

## References

- https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-service-other-languages
