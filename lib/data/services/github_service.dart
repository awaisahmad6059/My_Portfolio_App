import 'package:http/http.dart' as http;

class GithubService {
  static const String _baseUrl = 'https://api.github.com';
  static const String _username = 'awaisahmad6059';

  final http.Client _client;

  GithubService({http.Client? client}) : _client = client ?? http.Client();

  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.github.v3+json',
  };

  Future<http.Response> getUser() {
    return _client.get(
      Uri.parse('$_baseUrl/users/$_username'),
      headers: _headers,
    );
  }

  Future<http.Response> getRepositories() {
    return _client.get(
      Uri.parse(
        '$_baseUrl/users/$_username/repos?sort=updated&per_page=100&type=public',
      ),
      headers: _headers,
    );
  }

  void dispose() {
    _client.close();
  }
}
