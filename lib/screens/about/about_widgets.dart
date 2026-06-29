import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/utils/url_launcher_utils.dart';
import 'package:aak/models/admin_data.dart';

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
      onPressed: url.isNotEmpty ? () => UrlLauncherUtils.tryLaunch(url) : null,
      icon: Icon(icon, color: AppColors.white, size: AppDimens.iconMedium),
      splashRadius: 24,
      tooltip: url,
    );
  }
}

class AboutSocialIcons extends StatelessWidget {
  final AdminData admin;

  const AboutSocialIcons({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        AboutSocialIcon(
          icon: FontAwesomeIcons.instagram,
          url: admin.instagramUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: admin.linkedinUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.github,
          url: admin.githubUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.threads,
          url: admin.threadsUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.facebook,
          url: admin.facebookUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.whatsapp,
          url: admin.whatsappChannelUrl,
        ),
        AboutSocialIcon(
          icon: FontAwesomeIcons.snapchat,
          url: admin.snapchatUrl,
        ),
      ],
    );
  }
}
