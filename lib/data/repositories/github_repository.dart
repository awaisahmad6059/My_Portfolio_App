import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

    debugPrint('[GithubRepository] Fetching user data...');
    http.Response response;
    try {
      response = await _service.getUser();
    } catch (e, stack) {
      debugPrint('[GithubRepository] Network error fetching user: $e');
      debugPrint('[GithubRepository] Stack trace: $stack');
      if (_cachedUser != null) return _cachedUser!;
      rethrow;
    }

    debugPrint('[GithubRepository] User response: ${response.statusCode}');
    debugPrint('[GithubRepository] Body start: ${response.body.substring(0, response.body.length.clamp(0, 200))}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _cachedUser = GithubUserModel.fromJson(json);
      _lastFetchTime = DateTime.now();
      debugPrint('[GithubRepository] User parsed: ${_cachedUser!.login} (${_cachedUser!.publicRepos} repos, ${_cachedUser!.followers} followers)');
      return _cachedUser!;
    }

    if (response.statusCode == 404) {
      debugPrint('[GithubRepository] User not found (404)');
      throw GithubApiException('User not found', 404);
    }
    if (response.statusCode == 403) {
      debugPrint('[GithubRepository] Rate limited (403)');
      throw GithubApiException('Rate limit reached', 403);
    }

    if (_cachedUser != null) return _cachedUser!;
    throw GithubApiException(
      'Failed to load user data (${response.statusCode})',
      response.statusCode,
    );
  }

  Future<List<GithubRepoModel>> getRepositories() async {
    if (_isCacheValid && _cachedRepos != null) return _cachedRepos!;

    debugPrint('[GithubRepository] Fetching repositories...');
    http.Response response;
    try {
      response = await _service.getRepositories();
    } catch (e, stack) {
      debugPrint('[GithubRepository] Network error fetching repos: $e');
      debugPrint('[GithubRepository] Stack trace: $stack');
      if (_cachedRepos != null) return _cachedRepos!;
      rethrow;
    }

    debugPrint('[GithubRepository] Repos response: ${response.statusCode}');
    debugPrint('[GithubRepository] Headers: ${response.headers}');
    debugPrint('[GithubRepository] Body: ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}');

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      _cachedRepos = jsonList
          .map((e) => GithubRepoModel.fromJson(e as Map<String, dynamic>))
          .where((repo) => !repo.name.contains(RegExp(r'^\.')))
          .toList();
      _lastFetchTime = DateTime.now();
      debugPrint('[GithubRepository] Loaded ${_cachedRepos!.length} repos');
      return _cachedRepos!;
    }

    if (response.statusCode == 404) {
      debugPrint('[GithubRepository] User not found (404)');
      throw GithubApiException('User not found', 404);
    }
    if (response.statusCode == 403) {
      debugPrint('[GithubRepository] Rate limited (403)');
      throw GithubApiException('Rate limit reached', 403);
    }

    if (_cachedRepos != null) return _cachedRepos!;
    throw GithubApiException(
      'Failed to load repositories (${response.statusCode})',
      response.statusCode,
    );
  }

  void clearCache() {
    _cachedRepos = null;
    _cachedUser = null;
    _lastFetchTime = null;
    debugPrint('[GithubRepository] Cache cleared');
  }
}

class GithubApiException implements Exception {
  final String message;
  final int statusCode;

  const GithubApiException(this.message, this.statusCode);

  @override
  String toString() => 'GithubApiException($statusCode): $message';
}
