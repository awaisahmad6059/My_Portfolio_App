import 'package:aak/core/constants/app_urls.dart';

/// A language spoken by Awais along with its proficiency level.
class SpokenLanguage {
  final String name;
  final String proficiency;

  const SpokenLanguage({required this.name, required this.proficiency});
}

/// Formal education details.
class EducationInfo {
  final String degree;
  final String institution;
  final String period;
  final List<String> coursework;

  const EducationInfo({
    required this.degree,
    required this.institution,
    required this.period,
    required this.coursework,
  });
}

/// A single skill/technology and the category it belongs to.
class SkillInfo {
  final String name;
  final String category;

  const SkillInfo({required this.name, required this.category});
}

/// A service offered by Awais and a short description.
class ServiceInfo {
  final String title;
  final String description;

  const ServiceInfo({required this.title, required this.description});
}

/// A group of related projects.
class ProjectCategory {
  final String name;
  final String description;
  final List<String> projects;

  const ProjectCategory({
    required this.name,
    required this.description,
    required this.projects,
  });
}

/// Contact details.
class ContactInfo {
  final String email;
  final String phone;
  final String whatsappLink;
  final String resumeUrl;

  const ContactInfo({
    required this.email,
    required this.phone,
    required this.whatsappLink,
    required this.resumeUrl,
  });
}

/// A social media profile.
class SocialLink {
  final String platform;
  final String handle;
  final String url;

  const SocialLink({
    required this.platform,
    required this.handle,
    required this.url,
  });
}

/// Single source of truth for everything the assistant knows about Awais Ahmad.
///
/// This is static, typed data bundled inside the app so the chatbot works
/// fully offline with zero API calls.
class KnowledgeBase {
  const KnowledgeBase._();

  static const KnowledgeBase instance = KnowledgeBase._();

  static const String name = 'Awais Ahmad';
  static const String aka = 'AAK';
  static const String title = 'Software Developer';
  static const String altTitle = 'Mobile Application Developer';
  static const String location = 'Lahore, Punjab, Pakistan';
  static const String experienceSummary = '2-4 years';

  static const String careerObjective =
      'To become a highly skilled Software Engineer and Mobile Application '
      'Developer, building innovative, high-quality, and AI-powered '
      'applications that solve real-world problems. He aims to continuously '
      'improve his technical skills, contribute to impactful projects, and '
      'grow his career in Android, Flutter, and Artificial Intelligence '
      'while delivering value to clients and organizations.';

  static const List<String> strengths = [
    'Problem solving',
    'Self-learning',
    'UI/UX eye for design',
    'Fast delivery',
    'Detail-oriented',
    'Team player',
  ];

  static const EducationInfo education = EducationInfo(
    degree: 'Bachelor of Science (BS) in Computer Science',
    institution: 'COMSATS University Islamabad, Sahiwal Campus',
    period: 'August 2017 - January 2022',
    coursework: [
      'Object-Oriented Programming (OOP)',
      'Data Structures & Algorithms',
      'Database Systems',
      'Operating Systems',
      'Computer Networks',
      'Software Engineering',
      'Web Programming',
      'Data Mining',
      'Natural Language Processing',
      'Blockchain & Cryptocurrency',
      'Human-Computer Interaction',
    ],
  );

  static const List<SkillInfo> skills = [
    SkillInfo(name: 'Flutter', category: 'Development'),
    SkillInfo(name: 'Android (Kotlin & Java)', category: 'Development'),
    SkillInfo(name: 'Web Development', category: 'Development'),
    SkillInfo(name: 'React & React Native', category: 'Development'),
    SkillInfo(name: 'Firebase', category: 'Development'),
    SkillInfo(name: 'Google Gemini AI', category: 'Development'),
    SkillInfo(name: 'UI/UX Design', category: 'Development'),
    SkillInfo(name: 'Graphic Design', category: 'Design'),
    SkillInfo(name: 'Adobe Photoshop', category: 'Design'),
    SkillInfo(name: 'Adobe Premiere Pro', category: 'Design'),
    SkillInfo(name: 'Shopify', category: 'Marketing'),
    SkillInfo(name: 'Facebook Ads', category: 'Marketing'),
    SkillInfo(name: 'TikTok Ads', category: 'Marketing'),
  ];

  static const List<ServiceInfo> services = [
    ServiceInfo(
      title: 'Flutter App Development',
      description: 'Cross-platform mobile apps for Android and iOS.',
    ),
    ServiceInfo(
      title: 'Android App Development',
      description: 'Native Android apps using Kotlin and Java.',
    ),
    ServiceInfo(
      title: 'Web Development',
      description: 'Responsive websites and web applications.',
    ),
    ServiceInfo(
      title: 'UI/UX Design',
      description: 'Clean, modern user interfaces.',
    ),
    ServiceInfo(
      title: 'Graphic Design',
      description: 'Logos, posters, and social media creatives.',
    ),
    ServiceInfo(
      title: 'Video Editing',
      description: 'Editing using Adobe Premiere Pro.',
    ),
    ServiceInfo(
      title: 'Shopify Store Setup',
      description: 'E-commerce stores built on Shopify.',
    ),
    ServiceInfo(
      title: 'Facebook & TikTok Ads',
      description: 'Paid social media marketing campaigns.',
    ),
    ServiceInfo(
      title: 'Freelancing & Consulting',
      description: 'Remote development and software consulting.',
    ),
  ];

  static const List<ProjectCategory> projects = [
    ProjectCategory(
      name: 'Games',
      description: 'Interactive games built with Flutter and Dart.',
      projects: [
        'Car Race Game',
        'Balloon Pop Game',
        'Color Match Game',
        'Ludo Royale',
        'TicTacDuel',
        'TicTacToe',
      ],
    ),
    ProjectCategory(
      name: 'Utility & Productivity',
      description: 'Useful everyday apps and productivity tools.',
      projects: [
        'Tip Calculator',
        'Unit Calculator',
        'To-Do List',
        'Alarm',
        'NotePad',
        'Sticky Notes',
        'Notes with Dark Mode and PIN',
        'Quotes Saver',
        'Fancy Nickname Generator',
        'Tasbeh Counter',
        'Clean Paragraph',
        'Expense Tracker',
      ],
    ),
    ProjectCategory(
      name: 'Business & E-commerce',
      description: 'Systems that power shops, billing, and management.',
      projects: [
        'Smart Billing POS System',
        'Order Management',
        'CMS',
        'E-Commerce',
        'Remote Presence',
        'SmartKit',
      ],
    ),
    ProjectCategory(
      name: 'AI-Powered',
      description: 'Applications that integrate artificial intelligence.',
      projects: [
        'AI Pet Companion Pro',
        'AI ChatBox',
        'Portfolio with AI ChatBox',
      ],
    ),
    ProjectCategory(
      name: 'Portfolio & Web',
      description: 'Portfolio sites and web applications.',
      projects: [
        'My Portfolio App',
        'Portfolio Web',
        'Portfolio',
      ],
    ),
    ProjectCategory(
      name: 'Social',
      description: 'Social media related applications.',
      projects: [
        'Social Media App',
        'Al-Tabreed',
      ],
    ),
  ];

  static const List<String> achievements = [
    'Successfully developed and published 20+ Android and Flutter applications for clients on the Google Play Store.',
    'Developed more than 35 software projects across personal and client work.',
    'Built complete Android applications using Kotlin, Java, and Flutter.',
    'Developed AI-powered applications by integrating Google Gemini AI.',
    'Built modern POS, CMS, Portfolio, Billing, and Business Management applications.',
    'Experienced in publishing production-ready applications on the Google Play Store.',
    'Successfully completed Hifz-ul-Quran.',
  ];

  static const List<String> certifications = [
    'Hifz-ul-Quran Certificate',
    'JavaScript - The Complete Guide (Udemy)',
    'React - The Complete Guide (Udemy)',
    'React Native - The Practical Guide (Udemy)',
  ];

  static const List<SpokenLanguage> languages = [
    SpokenLanguage(name: 'Urdu', proficiency: 'Native'),
    SpokenLanguage(
      name: 'English',
      proficiency: 'Professional Working Proficiency',
    ),
    SpokenLanguage(name: 'Arabic', proficiency: 'Conversational'),
    SpokenLanguage(name: 'Punjabi', proficiency: 'Conversational'),
  ];

  static const ContactInfo contact = ContactInfo(
    email: AppUrls.emailAddress,
    phone: AppUrls.phoneNumber,
    whatsappLink: '${AppUrls.waMe}${AppUrls.whatsappNumber}',
    resumeUrl: AppUrls.resumeGoogleDrive,
  );

  static const List<SocialLink> socials = [
    SocialLink(
      platform: 'GitHub',
      handle: 'awaisahmad6059',
      url: AppUrls.github,
    ),
    SocialLink(
      platform: 'LinkedIn',
      handle: 'in/awaisahmad6059',
      url: AppUrls.linkedin,
    ),
    SocialLink(
      platform: 'Facebook',
      handle: 'kamyana786',
      url: AppUrls.facebook,
    ),
    SocialLink(
      platform: 'Instagram',
      handle: 'kamyana786',
      url: AppUrls.instagram,
    ),
    SocialLink(
      platform: 'Threads',
      handle: '@kamyana786',
      url: AppUrls.threads,
    ),
    SocialLink(
      platform: 'Snapchat',
      handle: 'kamyana786',
      url: AppUrls.snapchat,
    ),
    SocialLink(
      platform: 'WhatsApp Channel',
      handle: 'Awais Ahmad',
      url: AppUrls.whatsappChannel,
    ),
  ];
}
