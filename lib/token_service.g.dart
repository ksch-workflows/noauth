// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$TokenServiceRouter(TokenService service) {
  final router = Router();
  router.add('POST', r'/oauth/token', service.authorize);
  return router;
}
