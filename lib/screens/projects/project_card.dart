import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';
import 'package:aak/models/github_repo_model.dart';

class ProjectCard extends StatelessWidget {
  final GithubRepoModel repo;

  const ProjectCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMd,
        vertical: AppDimens.paddingSm,
      ),
      child: Card(
        color: AppColors.cardBackgroundAlt,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      repo.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppDimens.fontLg + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        UrlLauncherUtils.tryLaunch(repo.htmlUrl),
                    icon: const Icon(
                      FontAwesomeIcons.github,
                      color: AppColors.white,
                      size: AppDimens.iconMedium,
                    ),
                    tooltip: 'Open on GitHub',
                  ),
                ],
              ),
              if (repo.description != null &&
                  repo.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppDimens.paddingSm,
                  ),
                  child: Text(
                    repo.description!,
                    style: const TextStyle(
                      color: AppColors.white70,
                      fontSize: AppDimens.fontMd - 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: AppDimens.paddingMd),
              Row(
                children: [
                  if (repo.language != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingSm + 2,
                        vertical: AppDimens.paddingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(
                            AppDimens.radiusSmall + 2),
                      ),
                      child: Text(
                        repo.language!,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppDimens.fontXs + 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.paddingSm + 4),
                  ],
                  const Icon(Icons.star,
                      color: AppColors.white70,
                      size: AppDimens.iconSmall),
                  const SizedBox(width: AppDimens.paddingXs),
                  Text(
                    repo.stars.toString(),
                    style: const TextStyle(color: AppColors.white70),
                  ),
                  const SizedBox(width: AppDimens.paddingSm + 4),
                  const Icon(Icons.call_split,
                      color: AppColors.white70,
                      size: AppDimens.iconSmall),
                  const SizedBox(width: AppDimens.paddingXs),
                  Text(
                    repo.forks.toString(),
                    style: const TextStyle(color: AppColors.white70),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingSm - 2,
                      vertical: AppDimens.paddingXs - 1,
                    ),
                    decoration: BoxDecoration(
                      color: repo.visibility == 'public'
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusSmall),
                    ),
                    child: Text(
                      repo.visibility == 'public' ? 'Public' : 'Private',
                      style: TextStyle(
                        color: repo.visibility == 'public'
                            ? Colors.green
                            : Colors.orange,
                        fontSize: AppDimens.fontXs,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingSm),
              Text(
                'Updated ${repo.updatedAtFormatted}',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimens.fontXs + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
