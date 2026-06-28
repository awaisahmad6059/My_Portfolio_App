import 'package:flutter/material.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/widgets/entrance_animation.dart';

class FooterWidget extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateToTab;

  const FooterWidget({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return EntranceAnimation(
      index: 6,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.paddingLg,
          horizontal: AppDimens.paddingMd,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radiusMedium),
            topRight: Radius.circular(AppDimens.radiusMedium),
          ),
        ),
        child: Column(
          children: [
            if (onNavigateToTab != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QuickNavButton(
                    icon: Icons.home,
                    label: AppStrings.home,
                    onTap: () => onNavigateToTab!(0),
                  ),
                  const SizedBox(width: 24),
                  _QuickNavButton(
                    icon: Icons.code,
                    label: AppStrings.projects,
                    onTap: () => onNavigateToTab!(1),
                  ),
                  const SizedBox(width: 24),
                  _QuickNavButton(
                    icon: Icons.person,
                    label: AppStrings.aboutMe,
                    onTap: () => onNavigateToTab!(2),
                  ),
                  const SizedBox(width: 24),
                  _QuickNavButton(
                    icon: Icons.contacts,
                    label: AppStrings.contact,
                    onTap: () => onNavigateToTab!(3),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingMd),
              const Divider(color: AppColors.white70),
              const SizedBox(height: AppDimens.paddingSm),
            ],
            const Text(
              AppStrings.footerCopyright,
              style: TextStyle(
                color: AppColors.white70,
                fontSize: AppDimens.fontSm,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.footerCredit,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppDimens.fontXs,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickNavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white70,
                  fontSize: AppDimens.fontXs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
