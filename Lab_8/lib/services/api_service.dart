import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({
    http.Client? client,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client(),
       _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;
  final String baseUrl;
  final Duration timeout;

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'Máy chủ trả về lỗi ${response.statusCode}. Vui lòng thử lại.',
        );
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));
      if (data is! List) {
        throw const FormatException('Expected a JSON array');
      }

      return data.map((dynamic item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Expected a JSON object');
        }
        return Post.fromJson(item);
      }).toList();
    } on TimeoutException {
      throw const ApiException('Kết nối quá lâu. Vui lòng thử lại.');
    } on http.ClientException {
      throw const ApiException(
        'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.',
      );
    } on FormatException {
      throw const ApiException('Dữ liệu từ máy chủ không hợp lệ.');
    }
  }

  // The caller remains responsible for an injected client's lifecycle.
  void close() {
    if (_ownsClient) _client.close();
  }
}
