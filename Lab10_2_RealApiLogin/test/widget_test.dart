import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_2_realapilogin/services/api_auth_service.dart';
import 'package:lab10_2_realapilogin/services/auth_service.dart';

void main() {
  test('POST parses token and handles invalid credentials', () async {
    final api = ApiAuthService(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(jsonDecode(request.body)['username'], 'emilys');
        return http.Response(
          '{"accessToken":"token","username":"emilys"}',
          200,
        );
      }),
    );
    expect((await api.login('emilys', 'emilyspass')).token, 'token');
    final rejected = ApiAuthService(
      client: MockClient((_) async => http.Response('{}', 401)),
    );
    expect(rejected.login('bad', 'bad'), throwsA(isA<AuthException>()));
  });
}
