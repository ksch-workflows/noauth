import 'package:shelf/shelf.dart';

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

    return Response(200, body: 'Client ID: ${data['client_id']}');
  }

  Router get router => _$TokenServiceRouter(this);
}
