import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/providers/github_provider.dart';
import 'package:aak/screens/projects/project_card.dart';
import 'package:aak/widgets/entrance_animation.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(githubReposProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.projects,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: reposAsync.when(
        data: (repos) {
          if (repos.isEmpty) {
            return const Center(
              child: Text(
                'No repositories found',
                style: TextStyle(color: AppColors.white70),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(githubReposProvider);
              await ref.read(githubReposProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: AppDimens.paddingSm,
                bottom: AppDimens.paddingMd,
              ),
              itemCount: repos.length,
              itemBuilder: (context, index) {
                return EntranceAnimation(
                  index: index,
                  child: ProjectCard(repo: repos[index]),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  color: AppColors.white70,
                  size: 64,
                ),
                const SizedBox(height: AppDimens.paddingMd),
                const Text(
                  'Could not load repositories',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppDimens.fontLg,
                  ),
                ),
                const SizedBox(height: AppDimens.paddingSm),
                Text(
                  error.toString(),
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: AppDimens.fontSm,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.paddingLg),
                FilledButton.tonal(
                  onPressed: () => ref.invalidate(githubReposProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
