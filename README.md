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

### Create authorization code

```
$ curl -i 'localhost:7777/authorize?redirect_uri=http://localhost:8080/bff/callback&state=12323'
HTTP/1.1 302 Found
location: http://localhost:8080/bff/callback?code=W7S4aFZ&state=12323
```

### Create access token

*Request*

```
curl --request POST \
	--header "content-type: application/x-www-form-urlencoded" \
	--data "client_id=jnebdD0fczAHoEBVrr6lE7OAuYchc2ZR" \
	--data "client_secret=xxxxx" \
	--data "grant_type=authorization_code" \
	--data "redirect_uri=http://localhost/callback" \
	--data "code=W7S4aFZ" \
	"http://localhost:7777/oauth/token"
```

*Response*

```
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTA3Mjk5MjYsImV4cCI6MTY1MDgxNjMyNiwiaXNzIjoiaHR0cHM6Ly9ub2F1dGgtZ2Eyc3BlYm94YS1ldy5hLnJ1bi5hcHAvIn0.HGQfzXCi278UImFOjZn_vdxAflti-OkycjTTXA5RS9Y",
  "refresh_token": "N28Liif8KTFvjAET1uKhB8oYb6TNQqDNV2k4tq5SDxj5Jc",
  "id_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6Impkb2UiLCJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6Impkb2VAbm9hdXRoLWdhMnNwZWJveGEtZXcuYS5ydW4uYXBwIiwic3ViIjoiYXV0aDB8NjFjMzA2MDYyMDY4MGQwMDY5NmUwOWEyIiwiYXVkIjoiam5lYmREMGZjekFIb0VCVnJyNmxFN09BdVljaGMyWlIiLCJpYXQiOjE2NTA3Mjk5MjYsImV4cCI6MTY1MDgxNjMyNiwiaXNzIjoiaHR0cHM6Ly9ub2F1dGgtZ2Eyc3BlYm94YS1ldy5hLnJ1bi5hcHAvIn0.yhjrKoZI1dhh29y1Nz5qork4AsIjY32M37zuU0FFvSE",
  "scope": "openid profile email offline_access",
  "expires_in": 86400,
  "token_type": "Bearer"
}
```

### Approve access token

```
$ echo "token=$ACCESS_TOKEN" | curl -X POST --data @'-' -s localhost:7777/token-info
{
  "active": true,
  "client_id": null,
  "scope": null
}
```

### Create login

```
$ curl -X POST -i localhost:7777/login
HTTP/1.1 204 No Content
set-cookie: mockAccessToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTA3MjkzMzAsImV4cCI6MTY1MDgxNTczMCwiaXNzIjoiaHR0cHM6Ly9ub2F1dGgtZ2Eyc3BlYm94YS1ldy5hLnJ1bi5hcHAvIn0.Yph02Sn6BtOOvb-Tx_qtizvUZFO0zdWZkdFaJg3T7p0; Path=/; HttpOnly
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
