import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'token_service.dart';

part 'login_service.g.dart';

class LoginService {
  @Route.post('/login')
  Future<Response> login(Request request) async {
    var headers = {
      'Set-Cookie': 'mockAccessToken=${accessToken()}; Path=/; HttpOnly',
    };
    return Response(204, headers: headers);
  }

  Router get router => _$LoginServiceRouter(this);
}
