import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/core/constants/app_urls.dart';

class AdminData {
  final String fullName;
  final String jobTitle;
  final String aboutMe;
  final String bio;
  final String location;
  final String email;
  final String phone;
  final String? customImagePath;
  final String githubUsername;
  final String githubUrl;
  final String linkedinUrl;
  final String facebookUrl;
  final String instagramUrl;
  final String threadsUrl;
  final String snapchatUrl;
  final String whatsappChannelUrl;
  final String whatsappNumber;
  final String phoneNumber;
  final String emailAddress;

  const AdminData({
    required this.fullName,
    required this.jobTitle,
    this.aboutMe = '',
    this.bio = '',
    this.location = '',
    required this.email,
    required this.phone,
    this.customImagePath,
    required this.githubUsername,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.threadsUrl,
    required this.snapchatUrl,
    required this.whatsappChannelUrl,
    required this.whatsappNumber,
    required this.phoneNumber,
    required this.emailAddress,
  });

  factory AdminData.defaults() {
    return AdminData(
      fullName: AppStrings.userName,
      jobTitle: AppStrings.userTitle,
      email: AppUrls.emailAddress,
      phone: AppUrls.phoneNumber,
      githubUsername: 'awaisahmad6059',
      githubUrl: AppUrls.github,
      linkedinUrl: AppUrls.linkedin,
      facebookUrl: AppUrls.facebook,
      instagramUrl: AppUrls.instagram,
      threadsUrl: AppUrls.threads,
      snapchatUrl: AppUrls.snapchat,
      whatsappChannelUrl: AppUrls.whatsappChannel,
      whatsappNumber: AppUrls.whatsappNumber,
      phoneNumber: AppUrls.phoneNumber,
      emailAddress: AppUrls.emailAddress,
    );
  }

  AdminData copyWith({String? fullName, String? jobTitle, String? aboutMe,
    String? bio, String? location, String? email, String? phone,
    String? customImagePath, String? githubUsername, String? githubUrl,
    String? linkedinUrl, String? facebookUrl, String? instagramUrl,
    String? threadsUrl, String? snapchatUrl, String? whatsappChannelUrl,
    String? whatsappNumber, String? phoneNumber, String? emailAddress}) {
    return AdminData(
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      aboutMe: aboutMe ?? this.aboutMe,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      customImagePath: customImagePath,
      githubUsername: githubUsername ?? this.githubUsername,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      threadsUrl: threadsUrl ?? this.threadsUrl,
      snapchatUrl: snapchatUrl ?? this.snapchatUrl,
      whatsappChannelUrl: whatsappChannelUrl ?? this.whatsappChannelUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'jobTitle': jobTitle,
    'aboutMe': aboutMe,
    'bio': bio,
    'location': location,
    'email': email,
    'phone': phone,
    'customImagePath': customImagePath,
    'githubUsername': githubUsername,
    'githubUrl': githubUrl,
    'linkedinUrl': linkedinUrl,
    'facebookUrl': facebookUrl,
    'instagramUrl': instagramUrl,
    'threadsUrl': threadsUrl,
    'snapchatUrl': snapchatUrl,
    'whatsappChannelUrl': whatsappChannelUrl,
    'whatsappNumber': whatsappNumber,
    'phoneNumber': phoneNumber,
    'emailAddress': emailAddress,
  };

  factory AdminData.fromJson(Map<String, dynamic> json) {
    final defaults = AdminData.defaults();
    return AdminData(
      fullName: json['fullName'] as String? ?? defaults.fullName,
      jobTitle: json['jobTitle'] as String? ?? defaults.jobTitle,
      aboutMe: json['aboutMe'] as String? ?? defaults.aboutMe,
      bio: json['bio'] as String? ?? defaults.bio,
      location: json['location'] as String? ?? defaults.location,
      email: json['email'] as String? ?? defaults.email,
      phone: json['phone'] as String? ?? defaults.phone,
      customImagePath: json['customImagePath'] as String?,
      githubUsername: json['githubUsername'] as String? ?? defaults.githubUsername,
      githubUrl: json['githubUrl'] as String? ?? defaults.githubUrl,
      linkedinUrl: json['linkedinUrl'] as String? ?? defaults.linkedinUrl,
      facebookUrl: json['facebookUrl'] as String? ?? defaults.facebookUrl,
      instagramUrl: json['instagramUrl'] as String? ?? defaults.instagramUrl,
      threadsUrl: json['threadsUrl'] as String? ?? defaults.threadsUrl,
      snapchatUrl: json['snapchatUrl'] as String? ?? defaults.snapchatUrl,
      whatsappChannelUrl: json['whatsappChannelUrl'] as String? ?? defaults.whatsappChannelUrl,
      whatsappNumber: json['whatsappNumber'] as String? ?? defaults.whatsappNumber,
      phoneNumber: json['phoneNumber'] as String? ?? defaults.phoneNumber,
      emailAddress: json['emailAddress'] as String? ?? defaults.emailAddress,
    );
  }
}
