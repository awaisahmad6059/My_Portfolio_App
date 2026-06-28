import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  UrlLauncherUtils._();

  static Future<bool> tryLaunch(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
    return false;
  }
}
