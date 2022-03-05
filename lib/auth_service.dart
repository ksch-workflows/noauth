import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_service.g.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random rand = Random();

class AuthService {
  @Route.get('/authorize')
  Future<Response> authorize(Request request) async {
    var state = request.params['state'];
    var redirectUri = request.params['redirect_uri'];
    var code = createAuthorizationCode();

    var responseHeaders = <String, String>{
      'Location': 'http://localhost:8080/bff/callback?code=$code'
    };
    return Response(302, headers: responseHeaders);
  }

  Router get router => _$AuthServiceRouter(this);
}

String createAuthorizationCode() {
  return String.fromCharCodes(
    Iterable.generate(7, (_) => chars.codeUnitAt(rand.nextInt(chars.length))),
  );
}
