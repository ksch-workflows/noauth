import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:noauth/util.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'token_service.g.dart';

class TokenService {
  Router get router => _$TokenServiceRouter(this);

  @Route.post('/oauth/token')
  Future<Response> authorize(Request request) async {
    // Parse request payload
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
      'access_token': accessToken(),
      'refresh_token': randomString(46),
      'id_token': idToken(),
      'scope': 'openid profile email offline_access',
      'expires_in': 86400,
      'token_type': 'Bearer'
    };
    return Response(200, body: json.encode(payload));
  }

  @Route.post('/token-info')
  Future<Response> provideTokenInfo(Request request) async {
    // Parse request payload
    var data = <String, String>{};
    for (var d in (await request.readAsString()).split('&')) {
      var pair = d.split('=');
      data[pair[0]] = pair[1];
    }
    if (data['token'] == null) {
      return Response(400, body: 'Missing token data.\n');
    }
    var token = data['token']!;

    // Evaluate provided token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Create token info response
    var responsePayload = {
      'active': true,
      'client_id': decodedToken['client_id'],
      'scope': decodedToken['scope'],
    };
    var responseHeaders = {
      'Content-Type': 'application/json',
    };
    return Response(
      200,
      body: json.encode(responsePayload),
      headers: responseHeaders,
    );
  }
}

String accessToken() {
  final jwt = JWT({}, issuer: 'https://noauth-ga2speboxa-ew.a.run.app/');
  return jwt.sign(
    SecretKey('\$SIGNING_SECRET'),
    expiresIn: Duration(seconds: 86400),
  );
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
    expiresIn: Duration(seconds: 86400),
  );
}
