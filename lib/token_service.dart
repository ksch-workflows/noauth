import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';

part 'token_service.g.dart';

class TokenService {
  @Route.post('/oauth/token')
  Future<Response> authorize(Request request) async {
    // Parse request details
    var data = <String, String>{};
    for (var d in (await request.readAsString()).split('&')) {
      var pair = d.split('=');
      data[pair[0]] = pair[1];
    }

    // Validate headers
    var contentType = request.headers['content-type'];
    if (contentType == null) {
      return Response(400, body: "Missing header 'content-type'.\n");
    }
    if (contentType != 'application/x-www-form-urlencoded') {
      return Response(400, body: "Unsupported 'content-type'.\n");
    }

    // Validate form params
    var clientId = data['client_id'];
    if (clientId == null) {
      return Response(400, body: "Missing form param 'client_id'.\n");
    }
    var clientSecret = data['client_secret'];
    if (clientSecret == null) {
      return Response(400, body: "Missing form param 'client_secret'.\n");
    }
    var grantType = data['grant_type'];
    if (grantType == null) {
      return Response(400, body: "Missing form param 'grant_type'.\n");
    }
    var redirectUri = data['redirect_uri'];
    if (redirectUri == null) {
      return Response(400, body: "Missing form param 'redirect_uri'.\n");
    }
    var code = data['code'];
    if (code == null) {
      return Response(400, body: "Missing form param 'code'.\n");
    }

    // Create token response
    var payload = {
      'id_token': idToken(),
    };
    return Response(200, body: json.encode(payload));
  }

  Router get router => _$TokenServiceRouter(this);
}

String idToken() {
  final jwt = JWT(
    {
      'nickname': 'jdoe',
      'name': 'John Doe',
      'email': 'jdoe@noauth-ga2speboxa-ew.a.run.app',
      'sub': 'auth0|61c3060620680d00696e09a2',
      'aud': 'jnebdD0fczAHoEBVrr6lE7OAuYchc2ZR',
    },
    issuer: 'https://noauth-ga2speboxa-ew.a.run.app/',
  );
  return jwt.sign(
    SecretKey('\$SIGNING_SECRET'),
    expiresIn: Duration(hours: 1),
  );
}
