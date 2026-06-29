import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:aak/core/constants/app_assets.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';
import 'package:aak/core/utils/validators.dart';
import 'package:aak/providers/admin_provider.dart';
import 'package:aak/screens/contact/contact_widgets.dart';
import 'package:aak/widgets/entrance_animation.dart';
import 'package:aak/widgets/profile_image_widget.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  Future<String?> _showInputDialog(
    BuildContext context, {
    required String title,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text(AppStrings.open),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _launchWithInput(
    BuildContext context, {
    required String title,
    required String hint,
    required TextInputType keyboardType,
    required String Function(String input) buildUrl,
    bool isPhone = false,
    bool isEmail = false,
  }) async {
    final input = await _showInputDialog(
      context,
      title: title,
      hint: hint,
      keyboardType: keyboardType,
    );
    if (input == null || input.isEmpty) return;

    final isValid = isPhone
        ? Validators.isValidPhone(input)
        : isEmail
            ? Validators.isValidEmail(input)
            : Validators.isNotEmpty(input);

    if (!isValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.invalidInput)),
        );
      }
      return;
    }

    final url = buildUrl(input);
    final launched = await UrlLauncherUtils.tryLaunch(url);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotOpen)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customImage = ref.watch(adminImageProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SlidingSheet(
          elevation: 8,
          cornerRadius: AppDimens.radiusXLarge,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.38, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 25),
            child: AnimatedProfileImage(
              imageAsset: AppAssets.profileImage,
              heroTag: 'contactImage',
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
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(
                left: AppDimens.paddingLg,
                right: AppDimens.paddingLg,
                top: AppDimens.paddingXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EntranceAnimation(
                    index: 0,
                    child: const Text(
                      AppStrings.getInTouch,
                      style: TextStyle(
                        fontSize: AppDimens.fontLg,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.paddingLg),
                  EntranceAnimation(
                    index: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.paddingMd),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusLarge,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.white.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppDimens.paddingMd,
                        runSpacing: AppDimens.paddingMd,
                        children: [
                          ContactActionCard(
                            onPressed: () => _launchWithInput(
                              context,
                              title: AppStrings.enterWhatsAppNumber,
                              hint: AppStrings.phoneHint,
                              keyboardType: TextInputType.phone,
                              isPhone: true,
                              buildUrl: (input) =>
                                  'https://wa.me/$input',
                            ),
                            icon: FontAwesomeIcons.whatsapp,
                            label: AppStrings.whatsapp,
                          ),
                          ContactActionCard(
                            onPressed: () => _launchWithInput(
                              context,
                              title: AppStrings.enterPhoneNumber,
                              hint: AppStrings.phoneHint,
                              keyboardType: TextInputType.phone,
                              isPhone: true,
                              buildUrl: (input) => 'tel:$input',
                            ),
                            icon: Icons.phone,
                            label: AppStrings.call,
                          ),
                          ContactActionCard(
                            onPressed: () => _launchWithInput(
                              context,
                              title: AppStrings.enterPhoneNumber,
                              hint: AppStrings.phoneHint,
                              keyboardType: TextInputType.phone,
                              isPhone: true,
                              buildUrl: (input) => 'sms:$input',
                            ),
                            icon: Icons.message,
                            label: AppStrings.message,
                          ),
                          ContactActionCard(
                            onPressed: () => _launchWithInput(
                              context,
                              title: AppStrings.enterEmailAddress,
                              hint: AppStrings.emailHint,
                              keyboardType: TextInputType.emailAddress,
                              isEmail: true,
                              buildUrl: (input) => 'mailto:$input',
                            ),
                            icon: Icons.email,
                            label: AppStrings.email,
                          ),
                          ContactActionCard(
                            onPressed: () => _launchWithInput(
                              context,
                              title: AppStrings.enterUrl,
                              hint: AppStrings.urlHint,
                              keyboardType: TextInputType.url,
                              buildUrl: (input) {
                                if (!input.startsWith('http://') &&
                                    !input.startsWith('https://')) {
                                  return 'https://$input';
                                }
                                return input;
                              },
                            ),
                            icon: Icons.link,
                            label: AppStrings.openUrl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
