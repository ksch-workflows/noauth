import 'package:noauth/util.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'token_service.dart';

part 'login_service.g.dart';

class LoginService {

  @Route.get('/')
  Future<Response> welcome(Request _) async {
    return Response(200, body: 'Hello, World!');
  }

  @Route.get('/login')
  Future<Response> login(Request request) async {
    var params = request.queryParams;

    var headers = {
      'Set-Cookie': 'mockAccessToken=${accessToken()}; Path=/; Secure',
    };
    if (params['redirect_uri'] != null) {
      headers['Location'] = params['redirect_uri'];
      print(params['redirect_uri']);
      return Response(303, headers: headers);
    } else {
      return Response(204, headers: headers);
    }
  }

  Router get router => _$LoginServiceRouter(this);
}
