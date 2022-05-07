// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$LoginServiceRouter(LoginService service) {
  final router = Router();
  router.add('GET', r'/', service.welcome);
  router.add('GET', r'/login', service.login);
  return router;
}
