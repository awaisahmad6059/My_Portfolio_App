import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/data/repositories/github_repository.dart';
import 'package:aak/data/services/github_service.dart';
import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';

final githubServiceProvider = Provider<GithubService>((ref) {
  final service = GithubService();
  ref.onDispose(() => service.dispose());
  return service;
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
