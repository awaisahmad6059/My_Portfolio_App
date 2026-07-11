import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:aak/data/services/github_service.dart';
import 'package:aak/data/repositories/github_cache_repository.dart';
import 'package:aak/data/repositories/github_defaults.dart';
import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';

class GithubRepository {
  final GithubService _service;
  final GithubCacheRepository _cache;
  static const String _defaultUsername = 'awaisahmad6059';

  GithubRepository(this._service, {GithubCacheRepository? cache})
      : _cache = cache ?? GithubCacheRepository();

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
    } catch (e) {
      debugPrint('[GithubRepository] Network error fetching user: $e');
      return _fallbackUser(e);
    }

    debugPrint('[GithubRepository] User response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _cachedUser = GithubUserModel.fromJson(json);
      _lastFetchTime = DateTime.now();
      _cache.saveUser(_cachedUser!);
      return _cachedUser!;
    }

    debugPrint('[GithubRepository] API returned ${response.statusCode}');
    return _fallbackUser(GithubApiException(
      'GitHub API returned ${response.statusCode}',
      response.statusCode,
    ));
  }

  Future<List<GithubRepoModel>> getRepositories() async {
    if (_isCacheValid && _cachedRepos != null) return _cachedRepos!;

    debugPrint('[GithubRepository] Fetching repositories...');
    http.Response response;
    try {
      response = await _service.getRepositories();
    } catch (e) {
      debugPrint('[GithubRepository] Network error fetching repos: $e');
      return _fallbackRepos(e);
    }

    debugPrint('[GithubRepository] Repos response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      _cachedRepos = jsonList
          .map((e) => GithubRepoModel.fromJson(e as Map<String, dynamic>))
          .where((repo) => !repo.name.contains(RegExp(r'^\.')))
          .toList();
      _lastFetchTime = DateTime.now();
      _cache.saveRepos(_cachedRepos!);
      return _cachedRepos!;
    }

    debugPrint('[GithubRepository] API returned ${response.statusCode}');
    return _fallbackRepos(GithubApiException(
      'GitHub API returned ${response.statusCode}',
      response.statusCode,
    ));
  }

  Future<GithubUserModel> _fallbackUser(Object originalError) async {
    if (_cachedUser != null) return _cachedUser!;
    final cached = await _cache.loadUser();
    if (cached != null) return cached;
    if (_service.username == _defaultUsername) {
      debugPrint('[GithubRepository] Using built-in default user data');
      return defaultGithubUser();
    }
    throw originalError is GithubApiException
        ? originalError
        : GithubApiException(originalError.toString(), 0);
  }

  Future<List<GithubRepoModel>> _fallbackRepos(Object originalError) async {
    if (_cachedRepos != null) return _cachedRepos!;
    final cached = await _cache.loadRepos();
    if (cached != null && cached.isNotEmpty) return cached;
    if (_service.username == _defaultUsername) {
      debugPrint('[GithubRepository] Using built-in default repo data');
      return defaultGithubRepos();
    }
    throw originalError is GithubApiException
        ? originalError
        : GithubApiException(originalError.toString(), 0);
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
