import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/data/repositories/github_repository.dart';
import 'package:aak/data/services/github_service.dart';
import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';
import 'package:aak/models/admin_data.dart';
import 'package:aak/providers/admin_provider.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(() => client.close());
  return client;
});

/// Caches the last known GitHub username so it survives adminDataProvider's
/// loading flicker after invalidation.
final githubUsernameProvider = StateProvider<String>((ref) {
  return AdminData.defaults().githubUsername;
});

final githubTokenProvider = StateProvider<String>((ref) {
  return AdminData.defaults().githubToken;
});

final githubServiceProvider = Provider<GithubService>((ref) {
  final adminData = ref.watch(adminDataProvider).valueOrNull;
  final cachedUser = ref.watch(githubUsernameProvider);
  final cachedToken = ref.watch(githubTokenProvider);

  final username = adminData?.githubUsername;
  final token = adminData?.githubToken;
  final effective = (username != null && username.isNotEmpty)
      ? username
      : cachedUser;
  final effectiveToken = (token != null && token.isNotEmpty)
      ? token
      : cachedToken;

  if (username != null && username.isNotEmpty && username != cachedUser) {
    ref.read(githubUsernameProvider.notifier).state = username;
  }
  if (token != null && token.isNotEmpty && token != cachedToken) {
    ref.read(githubTokenProvider.notifier).state = token;
  }

  final client = ref.read(httpClientProvider);
  return GithubService(username: effective, token: effectiveToken, client: client);
});

final githubRepositoryProvider = Provider<GithubRepository>((ref) {
  return GithubRepository(ref.read(githubServiceProvider));
});

final githubUserProvider = FutureProvider<GithubUserModel>((ref) {
  return ref.read(githubRepositoryProvider).getUser();
});

final githubReposProvider = FutureProvider<List<GithubRepoModel>>((ref) {
  return ref.read(githubRepositoryProvider).getRepositories();
});
