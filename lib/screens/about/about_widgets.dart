import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aak/core/constants/app_urls.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';

class AboutSocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const AboutSocialIcon({
    super.key,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => UrlLauncherUtils.tryLaunch(url),
      icon: Icon(icon, color: AppColors.white, size: AppDimens.iconMedium),
      splashRadius: 24,
      tooltip: url,
    );
  }
}

class AboutSocialIcons extends StatelessWidget {
  const AboutSocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: const [
        AboutSocialIcon(
          icon: FontAwesomeIcons.instagram,
          url: AppUrls.instagram,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: AppUrls.linkedin,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.github,
          url: AppUrls.github,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.threads,
          url: AppUrls.threads,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.facebook,
          url: AppUrls.facebook,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.whatsapp,
          url: AppUrls.whatsappChannel,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.snapchat,
          url: AppUrls.snapchat,
        ),
      ],
    );
  }
}
