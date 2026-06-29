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

final githubServiceProvider = Provider<GithubService>((ref) {
  final adminData = ref.watch(adminDataProvider).valueOrNull;
  final cached = ref.watch(githubUsernameProvider);

  final username = adminData?.githubUsername;
  final effective = (username != null && username.isNotEmpty)
      ? username
      : cached;

  if (username != null && username.isNotEmpty && username != cached) {
    ref.read(githubUsernameProvider.notifier).state = username;
  }

  final client = ref.read(httpClientProvider);
  return GithubService(username: effective, client: client);
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
