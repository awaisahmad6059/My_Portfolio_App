import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:aak/core/constants/app_assets.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/core/routes/app_routes.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';
import 'package:aak/models/admin_data.dart';
import 'package:aak/providers/admin_provider.dart';
import 'package:aak/screens/home/home_widgets.dart';
import 'package:aak/widgets/pin_dialog.dart';
import 'package:aak/widgets/profile_image_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _launch(BuildContext context, String url) async {
    final launched = await UrlLauncherUtils.tryLaunch(url);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('${AppStrings.couldNotOpen} link')),
      );
    }
  }

  void _showWhatsAppDialog(BuildContext context, String whatsappNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.whatsapp),
        content: const Text(AppStrings.chatWithAwais),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _launch(context, 'https://wa.me/$whatsappNumber');
            },
            child: const Text(AppStrings.open),
          ),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.call),
        content: const Text(AppStrings.callAwais),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _launch(context, 'tel:$phoneNumber');
            },
            child: const Text(AppStrings.call),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.message),
        content: const Text(AppStrings.messageAwais),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _launch(context, 'sms:$phoneNumber');
            },
            child: const Text(AppStrings.message),
          ),
        ],
      ),
    );
  }

  Future<void> _onLongPress(BuildContext context) async {
    final isAuthenticated = await showDialog<bool>(
      context: context,
      builder: (_) => const PinDialog(),
    );
    if (isAuthenticated == true && context.mounted) {
      Navigator.of(context).pushNamed(AppRoutes.admin);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminDataProvider).valueOrNull ?? AdminData.defaults();
    final customImage = ref.watch(adminImageProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SlidingSheet(
        elevation: 8,
        cornerRadius: AppDimens.radiusXLarge,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.38, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final nameOffset = constraints.maxHeight > 600
                ? constraints.maxHeight * 0.45
                : constraints.maxHeight * 0.35;
            final buttonTop = constraints.maxHeight * 0.14;
            return Stack(
              children: [
                GestureDetector(
                  onLongPress: () => _onLongPress(context),
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: AnimatedProfileImage(
                      imageAsset: AppAssets.profileImage,
                      heroTag: 'profileImage',
                      customImageBytes: customImage,
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
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: nameOffset),
                  child: Column(
                    children: [
                      Text(
                        admin.fullName,
                        style: const TextStyle(
                          fontFamily: 'Soho',
                          color: AppColors.white,
                          fontSize: AppDimens.fontXxl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        admin.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Soho',
                          color: AppColors.white,
                          fontSize: AppDimens.fontLg,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: buttonTop,
                  left: AppDimens.paddingSm,
                  child: SocialButtonColumn(
                    buttons: [
                      SocialButton(
                        icon: FontAwesomeIcons.whatsapp,
                        onPressed: () =>
                            _showWhatsAppDialog(context, admin.whatsappNumber),
                      ),
                      SocialButton(
                        icon: Icons.phone,
                        onPressed: () =>
                            _showCallDialog(context, admin.phoneNumber),
                      ),
                      SocialButton(
                        icon: Icons.message,
                        onPressed: () =>
                            _showMessageDialog(context, admin.phoneNumber),
                      ),
                      SocialButton(
                        icon: FontAwesomeIcons.facebook,
                        onPressed: () => _launch(context, admin.facebookUrl),
                      ),
                      SocialButton(
                        icon: FontAwesomeIcons.threads,
                        onPressed: () => _launch(context, admin.threadsUrl),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: buttonTop,
                  right: AppDimens.paddingSm,
                  child: SocialButtonColumn(
                    buttons: [
                      SocialButton(
                        icon: FontAwesomeIcons.linkedin,
                        onPressed: () => _launch(context, admin.linkedinUrl),
                      ),
                      SocialButton(
                        icon: FontAwesomeIcons.instagram,
                        onPressed: () => _launch(context, admin.instagramUrl),
                      ),
                      SocialButton(
                        icon: FontAwesomeIcons.snapchat,
                        onPressed: () => _launch(context, admin.snapchatUrl),
                      ),
                      SocialButton(
                        icon: Icons.email,
                        onPressed: () =>
                            _launch(context, 'mailto:${admin.emailAddress}'),
                      ),
                      SocialButton(
                        icon: FontAwesomeIcons.github,
                        onPressed: () => _launch(context, admin.githubUrl),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        builder: (context, state) {
          return const SingleChildScrollView(
            child: HomeSlidingSheet(),
          );
        },
      ),
    );
  }
}
