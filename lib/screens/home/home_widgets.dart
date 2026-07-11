import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/data/portfolio_data.dart';
import 'package:aak/providers/github_provider.dart';
import 'package:aak/widgets/entrance_animation.dart';

class AnimatedCount extends StatefulWidget {
  final int target;
  final TextStyle? style;

  const AnimatedCount({super.key, required this.target, this.style});

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _countAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _countAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedBuilder(
          animation: _countAnimation,
          builder: (context, child) {
            return Text(
              (widget.target * _countAnimation.value).round().toString(),
              style: widget.style,
            );
          },
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final int target;
  final String label;

  const StatItem({
    super.key,
    required this.target,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCount(
          target: target,
          style: const TextStyle(
            fontSize: AppDimens.fontXl,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppDimens.fontSm,
          ),
        ),
      ],
    );
  }
}

class StatsSection extends ConsumerStatefulWidget {
  const StatsSection({super.key});

  @override
  ConsumerState<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends ConsumerState<StatsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _startAutoRefresh());
  }

  void _startAutoRefresh() {
    Timer.periodic(const Duration(minutes: 3), (_) {
      if (mounted) ref.invalidate(githubUserProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(githubUserProvider);
    return userAsync.when(
      data: (user) => EntranceFade(
        key: ValueKey('stats-${user.publicRepos}-${user.followers}-${user.following}'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatItem(target: user.publicRepos, label: 'Repositories'),
            StatItem(target: user.followers, label: 'Followers'),
            StatItem(target: user.following, label: 'Following'),
          ],
        ),
      ),
      loading: () => const _SkeletonRow(),
      error: (error, _) => _buildError(context, ref),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: PortfolioData.fallbackStats
              .map((s) => StatItem(
                    target: int.tryParse(s.value) ?? 0,
                    label: s.label.trim(),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppDimens.paddingSm),
        TextButton.icon(
          onPressed: () => ref.invalidate(githubUserProvider),
          icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
          label: const Text(
            'Retry',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.fontSm,
            ),
          ),
        ),
      ],
    );
  }
}

class EntranceFade extends StatefulWidget {
  final Widget child;

  const EntranceFade({super.key, required this.child});

  @override
  State<EntranceFade> createState() => _EntranceFadeState();
}

class _EntranceFadeState extends State<EntranceFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: widget.child);
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SkeletonStat(),
        _SkeletonStat(),
        _SkeletonStat(),
      ],
    );
  }
}

class _SkeletonStat extends StatefulWidget {
  const _SkeletonStat();

  @override
  State<_SkeletonStat> createState() => _SkeletonStatState();
}

class _SkeletonStatState extends State<_SkeletonStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (_controller.value * 0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 70,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SkillCard extends StatelessWidget {
  final IconData icon;
  final String tech;

  const SkillCard({super.key, required this.icon, required this.tech});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      height: 115,
      child: Card(
        margin: EdgeInsets.zero,
        color: AppColors.cardBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(height: AppDimens.paddingSm + 2),
            Text(
              tech,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.fontMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecializationsSection extends StatelessWidget {
  const SpecializationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EntranceAnimation(
          index: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: PortfolioData.skills
                .sublist(0, 3)
                .map((s) => SkillCard(icon: s.icon, tech: s.name))
                .toList(),
          ),
        ),
        const SizedBox(height: AppDimens.paddingSm + 2),
        EntranceAnimation(
          index: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: PortfolioData.skills
                .sublist(3, 6)
                .map((s) => SkillCard(icon: s.icon, tech: s.name))
                .toList(),
          ),
        ),
        const SizedBox(height: AppDimens.paddingSm + 2),
        EntranceAnimation(
          index: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: PortfolioData.skills
                .sublist(6, 9)
                .map((s) => SkillCard(icon: s.icon, tech: s.name))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: null,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.background,
      mini: true,
      child: Icon(icon, size: AppDimens.iconSmall),
    );
  }
}

class SocialButtonColumn extends StatelessWidget {
  final List<Widget> buttons;
  final double spacing;

  const SocialButtonColumn({
    super.key,
    required this.buttons,
    this.spacing = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < buttons.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          buttons[i],
        ],
      ],
    );
  }
}

class HomeSlidingSheet extends StatelessWidget {
  const HomeSlidingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.paddingLg,
        right: AppDimens.paddingLg,
        top: AppDimens.paddingXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatsSection(),
          const SizedBox(height: AppDimens.paddingXl),
          EntranceAnimation(
            index: 1,
            child: const Text(
              AppStrings.specializedIn,
              style: TextStyle(
                fontSize: AppDimens.fontLg,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.paddingSm + 2),
          const SpecializationsSection(),
        ],
      ),
    );
  }
}
