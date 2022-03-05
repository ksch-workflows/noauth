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
dart bin/server.dart 9876
```

## Usage

```
$ curl -i 'localhost:9876/authorize?redirect_uri=http://localhost:8080/bff/callback&state=12323'
HTTP/1.1 302 Found
location: http://localhost:8080/bff/callback?code=W7S4aFZ&state=12323
date: Sat, 05 Mar 2022 18:11:33 GMT
content-length: 0
x-frame-options: SAMEORIGIN
content-type: text/plain; charset=utf-8
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
server: dart:io with Shelf
```

## Run server via Docker

```bash
# Build docker image
docker build . -t noauth

# Run in daemon mode
docker run -d -p 7777:8080 noauth

# Run with attached terminal
docker run -it -p 7777:8080 noauth

# Try request
curl localhost:7777/
```

## Development

### Generate routes

```
dart run build_runner build
```

### Snippets

**GET request***

```dart
@Route.get('/echo/<message>')
Future<Response> getMessage(Request request, String message) async {
  return Response.ok('$message\n$message\n$message\n');
}
```

**Post request**

```dart
@Route.post('/create/<id>/something')
Future<Response> createSomething(Request request, String id) async {
  var body = await request.jsonBody;
  body['msg'] = '${body['msg']} $id ${body['msg']}';
  return Response(201, body: json.encode(body));
}
```

**Content type header**

```dart
var headers = {'content-type': 'application/json'};
```
