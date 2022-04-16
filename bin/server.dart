import 'dart:io';

import 'package:noauth/auth_service.dart';
import 'package:noauth/token_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

const int defaultPort = 8080;

var _authService = AuthService();
var _tokenService = TokenService();

void main(List<String> args) async {
  var _handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addMiddleware(corsHeaders(
        headers: {
          'Access-Control-Allow-Origin': '*',
        },
      ))
      .addHandler(Cascade()
          .add(
            _authService.router,
          )
          .add(
            _tokenService.router,
          )
          .handler);
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
