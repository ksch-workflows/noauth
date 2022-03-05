import 'dart:io';

import 'package:noauth/auth_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

const int defaultPort = 8080;

var _authService = AuthService();

void main(List<String> args) async {
  var _handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Cascade().add(_authService.router).handler);
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
