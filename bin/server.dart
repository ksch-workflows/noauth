import 'dart:io';

import 'package:noauth/service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

const int defaultPort = 8080;

var _service = ExampleService();

var _fallbackRouter = Router(notFoundHandler: (request) {
  var headers = {'content-type': 'application/json'};
  return Response.ok(
    '{"message": "Catching all requests by default!"}',
    headers: headers,
  );
});

void main(List<String> args) async {
  var _handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Cascade().add(_service.router).add(_fallbackRouter).handler);
  var server = await serve(_handler, InternetAddress.anyIPv4, args.port);
  print('Server listening on port ${server.port}');
}

extension ArgsParser on List<String> {
  int get port {
    var environmentConfig = Platform.environment['PORT'];
    if (environmentConfig != null) {
      return int.parse(environmentConfig);
    }

    if (length > 0) {
      var argumentConfig = int.tryParse(first);
      if (argumentConfig != null) {
        return argumentConfig;
      }
    }

    return defaultPort;
  }
}
