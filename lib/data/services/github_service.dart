import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GithubService {
  static const String _baseUrl = 'https://api.github.com';
  final String username;
  final http.Client _client;

  GithubService({required this.username, required http.Client client})
      : _client = client;

  Map<String, String> get _headers => {
    'Accept': 'application/vnd.github.v3+json',
    'User-Agent': 'AAK-Portfolio/1.0',
  };

  Future<http.Response> getUser() {
    final uri = Uri.parse('$_baseUrl/users/$username');
    debugPrint('[GithubService] GET $uri (username: $username)');
    return _client.get(uri, headers: _headers);
  }

  Future<http.Response> getRepositories() {
    final uri = Uri.parse(
      '$_baseUrl/users/$username/repos?sort=updated&per_page=100',
    );
    debugPrint('[GithubService] GET $uri (username: $username)');
    return _client.get(uri, headers: _headers);
  }
}
