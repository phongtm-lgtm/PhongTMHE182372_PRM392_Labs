import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8_networking/models/post.dart';
import 'package:lab8_networking/services/api_service.dart';

void main() {
  test('Post.fromJson maps fields', () {
    final post = Post.fromJson({
      'userId': 2,
      'id': 3,
      'title': 'Title',
      'body': 'Body',
    });
    expect(post.userId, 2);
    expect(post.id, 3);
    expect(post.title, 'Title');
    expect(post.body, 'Body');
  });

  test('GET /posts returns model objects', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(
        request.url.toString(),
        'https://jsonplaceholder.typicode.com/posts',
      );
      return http.Response(
        '[{"userId":1,"id":1,"title":"Title","body":"Body"}]',
        200,
      );
    });
    addTearDown(client.close);
    final posts = await ApiService(client: client).fetchPosts();
    expect(posts.single.title, 'Title');
  });

  for (final body in ['not json', '{}', '[1]', '[{"id":1}]']) {
    test('Rejects malformed response: $body', () async {
      final client = MockClient((_) async => http.Response(body, 200));
      addTearDown(client.close);
      await expectLater(
        ApiService(client: client).fetchPosts(),
        throwsA(isA<ApiException>()),
      );
    });
  }

  test('Converts connection failures into friendly errors', () async {
    final client = MockClient(
      (_) async => throw http.ClientException('Offline'),
    );
    addTearDown(client.close);
    await expectLater(
      ApiService(client: client).fetchPosts(),
      throwsA(isA<ApiException>()),
    );
  });

  test('Handles timeout', () async {
    final client = MockClient((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return http.Response('[]', 200);
    });
    addTearDown(client.close);
    await expectLater(
      ApiService(
        client: client,
        timeout: const Duration(milliseconds: 1),
      ).fetchPosts(),
      throwsA(isA<ApiException>()),
    );
  });
}
