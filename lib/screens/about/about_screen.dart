import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/constants/app_assets.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/core/constants/app_urls.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';
import 'package:aak/providers/resume_provider.dart';
import 'package:aak/widgets/footer_widget.dart';
import 'package:aak/widgets/shimmer_loading.dart';
import 'package:aak/screens/about/about_widgets.dart';
import 'package:aak/widgets/entrance_animation.dart';
import 'package:aak/widgets/profile_image_widget.dart';

class AboutScreen extends ConsumerStatefulWidget {
  final void Function(int tabIndex)? onNavigateToTab;

  const AboutScreen({super.key, this.onNavigateToTab});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  bool _isUpdatingResume = false;

  Future<void> _pickResume() async {
    setState(() => _isUpdatingResume = true);
    try {
      debugPrint('[AboutScreen] Starting resume pick...');
      final resumeService = ref.read(resumeServiceProvider);
      final resumeRepo = ref.read(resumeRepositoryProvider);

      final storedData = await resumeService.pickAndSavePdf();
      if (storedData == null) {
        debugPrint('[AboutScreen] pickAndSavePdf returned null (cancelled or failed)');
        return;
      }

      if (!kIsWeb) {
        final exists = await resumeService.hasExistingFile(storedData);
        if (!exists) {
          debugPrint('[AboutScreen] ERROR: Saved file does not exist');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.failedToUpdateResume)),
            );
          }
          return;
        }
      }

      debugPrint('[AboutScreen] Saving resume data to SharedPreferences...');
      await resumeRepo.saveResumeData(storedData);

      ref.invalidate(resumeDataProvider);
      debugPrint('[AboutScreen] Provider invalidated, resume updated successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.resumeUpdated)),
        );
      }
    } catch (e, stack) {
      debugPrint('[AboutScreen] Error updating resume: $e');
      debugPrint('[AboutScreen] Stack trace: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.failedToUpdateResume)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingResume = false);
    }
  }

  Future<void> _openResume() async {
    try {
      debugPrint('[AboutScreen] Opening resume...');
      final resumeRepo = ref.read(resumeRepositoryProvider);
      final data = await resumeRepo.getResumeData();

      if (data == null) {
        debugPrint('[AboutScreen] No resume data saved');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.noResumeFound)),
          );
        }
        return;
      }

      if (!kIsWeb) {
        final exists = await ref.read(resumeServiceProvider).hasExistingFile(data);
        if (!exists) {
          debugPrint('[AboutScreen] File no longer exists, clearing data');
          await resumeRepo.clearResumeData();
          ref.invalidate(resumeDataProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.resumeFileNotFound)),
            );
          }
          return;
        }
      }

      debugPrint('[AboutScreen] Opening resume...');
      final opened = await ref.read(resumeServiceProvider).openResume(data);
      if (!opened) {
        debugPrint('[AboutScreen] Failed to open the resume');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.couldNotOpenResume)),
          );
        }
      } else {
        debugPrint('[AboutScreen] Resume opened successfully');
      }
    } catch (e, stack) {
      debugPrint('[AboutScreen] Error opening resume: $e');
      debugPrint('[AboutScreen] Stack trace: $stack');
    }
  }

  Future<void> _shareResume() async {
    try {
      debugPrint('[AboutScreen] Sharing resume...');
      final resumeRepo = ref.read(resumeRepositoryProvider);
      final data = await resumeRepo.getResumeData();

      if (data == null) {
        debugPrint('[AboutScreen] No resume data saved for sharing');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.noResumeFound)),
          );
        }
        return;
      }

      debugPrint('[AboutScreen] Sharing resume...');
      await ref.read(resumeServiceProvider).shareResume(data);
      debugPrint('[AboutScreen] Share completed');
    } catch (e, stack) {
      debugPrint('[AboutScreen] Error sharing resume: $e');
      debugPrint('[AboutScreen] Stack trace: $stack');
    }
  }

  Future<void> _downloadResume() async {
    if (kIsWeb) {
      try {
        debugPrint('[AboutScreen] Downloading resume (web)...');
        final resumeRepo = ref.read(resumeRepositoryProvider);
        final data = await resumeRepo.getResumeData();

        if (data == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.noResumeFound)),
            );
          }
          return;
        }

        await ref.read(resumeServiceProvider).downloadResume(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resume downloaded successfully.')),
          );
        }
      } catch (e, stack) {
        debugPrint('[AboutScreen] Error downloading resume: $e');
        debugPrint('[AboutScreen] Stack trace: $stack');
      }
      return;
    }
    UrlLauncherUtils.tryLaunch(AppUrls.resumeGoogleDrive);
  }

  @override
  Widget build(BuildContext context) {
    final resumeAsync = ref.watch(resumeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topSectionRatio =
                constraints.maxHeight > 700 ? 0.55 : 0.50;
            final imageHeight = constraints.maxHeight > 700
                ? 350.0
                : constraints.maxHeight * 0.55;
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: AnimatedProfileImage(
                    imageAsset: AppAssets.profileImage,
                    heroTag: 'profileImage',
                    height: imageHeight,
                    shaderMaskGradient: const LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background,
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: constraints.maxHeight * topSectionRatio,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimens.paddingSm + 2),
                        EntranceAnimation(
                          index: 0,
                          child: const Text(
                            AppStrings.helloIAm,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimens.fontXl,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.paddingSm + 2),
                        EntranceAnimation(
                          index: 1,
                          child: const Text(
                            AppStrings.userName,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimens.fontXxl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        EntranceAnimation(
                          index: 2,
                          child: const Text(
                            AppStrings.userTitle,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimens.fontLg,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.paddingLg),
                        EntranceAnimation(
                          index: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ResumeButton(
                                label: AppStrings.myResume,
                                onPressed: _openResume,
                              ),
                              const SizedBox(width: 16),
                              _ResumeButton(
                                label: AppStrings.updateResume,
                                onPressed: _isUpdatingResume ? null : _pickResume,
                                isLoading: _isUpdatingResume,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.paddingXl),
                        EntranceAnimation(
                          index: 4,
                          child: const AboutSocialIcons(),
                        ),
                        const SizedBox(height: AppDimens.paddingXl),
                        _buildResumeSection(resumeAsync),
                        const SizedBox(height: AppDimens.paddingLg),
                        FooterWidget(
                          onNavigateToTab: widget.onNavigateToTab,
                        ),
                        const SizedBox(height: AppDimens.paddingMd),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResumeSection(AsyncValue<String?> resumeAsync) {
    return EntranceAnimation(
      index: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMd),
        padding: const EdgeInsets.all(AppDimens.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.resumeSection,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.fontLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.paddingSm),
            resumeAsync.when(
              data: (path) => Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _IconActionButton(
                    icon: Icons.visibility,
                    label: AppStrings.previewResume,
                    onPressed: _openResume,
                  ),
                  _IconActionButton(
                    icon: Icons.download,
                    label: AppStrings.downloadResume,
                    onPressed: _downloadResume,
                  ),
                  _IconActionButton(
                    icon: Icons.share,
                    label: AppStrings.shareResume,
                    onPressed: _shareResume,
                  ),
                ],
              ),
              loading: () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShimmerButton(width: 100, height: 40),
                  SizedBox(width: 12),
                  ShimmerButton(width: 100, height: 40),
                  SizedBox(width: 12),
                  ShimmerButton(width: 100, height: 40),
                ],
              ),
              error: (_, __) => Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _IconActionButton(
                    icon: Icons.visibility,
                    label: AppStrings.previewResume,
                    onPressed: _openResume,
                  ),
                  _IconActionButton(
                    icon: Icons.download,
                    label: AppStrings.downloadResume,
                    onPressed: _downloadResume,
                  ),
                  _IconActionButton(
                    icon: Icons.share,
                    label: AppStrings.shareResume,
                    onPressed: _shareResume,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _ResumeButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<_ResumeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              onTapDown: (_) => _scaleController.forward(),
              onTapUp: (_) => _scaleController.reverse(),
              onTapCancel: () => _scaleController.reverse(),
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              child: SizedBox(
                width: 120,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: widget.onPressed != null
                        ? AppColors.white
                        : AppColors.white70,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusSmall),
                  ),
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : Text(
                          widget.label,
                          style: TextStyle(
                            color: widget.onPressed != null
                                ? AppColors.background
                                : AppColors.background,
                            fontSize: AppDimens.fontSm,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IconActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _IconActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              onTapDown: (_) => _scaleController.forward(),
              onTapUp: (_) => _scaleController.reverse(),
              onTapCancel: () => _scaleController.reverse(),
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusSmall),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon,
                        color: AppColors.white, size: AppDimens.iconSmall),
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppDimens.fontSm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
