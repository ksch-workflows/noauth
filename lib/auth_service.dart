import 'dart:math';

import 'package:shelf/shelf.dart';

import 'package:shelf_router/shelf_router.dart';

part 'auth_service.g.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random rand = Random();

class AuthService {
  @Route.get('/authorize')
  Future<Response> authorize(Request request) async {
    // Parse request params
    var params = request.requestedUri.queryParameters;
    if (params['redirect_uri'] == null) {
      return Response(400, body: 'Missing redirect_uri param.\n');
    }
    var redirectUri = Uri.parse(params['redirect_uri']!);
    var state = params['state'];

    // Simulate authorization success
    var location = Uri(
        scheme: redirectUri.scheme,
        userInfo: redirectUri.userInfo,
        host: redirectUri.host,
        port: redirectUri.port,
        path: redirectUri.path,
        queryParameters: {
          'code': createAuthorizationCode(),
          if (state != null) 'state': state,
        });

    // Create response
    var responseHeaders = <String, String>{'Location': location.toString()};
    return Response(302, headers: responseHeaders);
  }

  Router get router => _$AuthServiceRouter(this);
}

String createAuthorizationCode() {
  return String.fromCharCodes(
    Iterable.generate(7, (_) => chars.codeUnitAt(rand.nextInt(chars.length))),
  );
}
