import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rand = Random();

extension RequestExtension on Request {
  Future<dynamic> get jsonBody async {
    return json.decode(await readAsString());
  }
}

String randomString(int length) {
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => _chars.codeUnitAt(
      _rand.nextInt(_chars.length),
    ),
  ));
}
