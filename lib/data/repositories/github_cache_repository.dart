import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';

class GithubCacheRepository {
  static const String _reposKey = 'github_cached_repos';
  static const String _userKey = 'github_cached_user';

  Future<void> saveRepos(List<GithubRepoModel> repos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = repos.map((r) => r.toJson()).toList();
      await prefs.setString(_reposKey, jsonEncode(jsonList));
      debugPrint('[GithubCache] Saved ${repos.length} repos');
    } catch (e) {
      debugPrint('[GithubCache] Error saving repos: $e');
    }
  }

  Future<List<GithubRepoModel>?> loadRepos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_reposKey);
      if (jsonStr == null) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final repos = list.map((e) => GithubRepoModel.fromJson(e as Map<String, dynamic>)).toList();
      debugPrint('[GithubCache] Loaded ${repos.length} cached repos');
      return repos;
    } catch (e) {
      debugPrint('[GithubCache] Error loading repos: $e');
      return null;
    }
  }

  Future<void> saveUser(GithubUserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      debugPrint('[GithubCache] Saved user: ${user.login}');
    } catch (e) {
      debugPrint('[GithubCache] Error saving user: $e');
    }
  }

  Future<GithubUserModel?> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_userKey);
      if (jsonStr == null) return null;
      return GithubUserModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[GithubCache] Error loading user: $e');
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reposKey);
    await prefs.remove(_userKey);
    debugPrint('[GithubCache] Cache cleared');
  }
}
