import 'dart:convert';
import 'package:aak/data/services/github_service.dart';
import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';

class GithubRepository {
  final GithubService _service;

  GithubRepository(this._service);

  List<GithubRepoModel>? _cachedRepos;
  GithubUserModel? _cachedUser;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  bool get _isCacheValid =>
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  Future<GithubUserModel> getUser() async {
    if (_isCacheValid && _cachedUser != null) return _cachedUser!;

    final response = await _service.getUser();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _cachedUser = GithubUserModel.fromJson(json);
      _lastFetchTime = DateTime.now();
      return _cachedUser!;
    }
    if (_cachedUser != null) return _cachedUser!;
    throw GithubApiException(
      'Failed to load user data',
      response.statusCode,
    );
  }

  Future<List<GithubRepoModel>> getRepositories() async {
    if (_isCacheValid && _cachedRepos != null) return _cachedRepos!;

    final response = await _service.getRepositories();
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      _cachedRepos = jsonList
          .map((e) => GithubRepoModel.fromJson(e as Map<String, dynamic>))
          .where((repo) => !repo.name.contains(RegExp(r'^\.')))
          .toList();
      _lastFetchTime = DateTime.now();
      return _cachedRepos!;
    }
    if (_cachedRepos != null) return _cachedRepos!;
    throw GithubApiException(
      'Failed to load repositories',
      response.statusCode,
    );
  }

  void clearCache() {
    _cachedRepos = null;
    _cachedUser = null;
    _lastFetchTime = null;
  }
}

class GithubApiException implements Exception {
  final String message;
  final int statusCode;

  const GithubApiException(this.message, this.statusCode);

  @override
  String toString() => 'GithubApiException($statusCode): $message';
}
