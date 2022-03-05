# Mock Server

This is a template repository which has the intention to make it quick and easy to build mock servers with
the help of the [Dart](https://www.dart.dev) programming language.

## Dependencies

- [Dart](https://www.dart.dev): Required to configure and run the mock server
- [Docker](https://www.docker.com): (Optional) Required to package and publish the mock server

## Getting started

The intended usage is that you copy this repository and then adopt it.

```bash
PROJECT_NAME=example
DEFAULT_BRANCH=master

{
git clone git@github.com:experimental-software/mock_server.git $PROJECT_NAME
cd $PROJECT_NAME
git checkout --orphan $DEFAULT_BRANCH
git add .
git commit -m "Initial commit"
}
```

## Run server via Dart VM

```
# Run server on default port 8080
dart bin/server.dart

# Run server on specific port
dart bin/server.dart 9876

# Run server with hot reload
ENABLE_VM_SERVICE=true dart --enable-vm-service bin/server.dart
```

## Run server via Docker

```bash
# Build docker image
docker build . -t example_mock_server

# Run in daemon mode
docker run -d -p 7777:8080 example_mock_server

# Run with attached terminal
docker run -it -p 7777:8080 example_mock_server

# Try request
curl localhost:7777/
```

## Development

### Generate routes

```
dart pub run build_runner build
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
