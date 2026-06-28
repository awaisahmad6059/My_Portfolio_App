import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aak/models/skill_model.dart';
import 'package:aak/models/statistic_model.dart';

class PortfolioData {
  PortfolioData._();

  static const List<StatisticModel> fallbackStats = [
    StatisticModel(value: '24', label: 'Repositories'),
    StatisticModel(value: '18', label: 'Followers'),
    StatisticModel(value: '12', label: 'Following'),
  ];

  static const List<SkillModel> skills = [
    SkillModel(icon: Icons.android, name: 'Android'),
    SkillModel(icon: Icons.flutter_dash, name: 'Flutter'),
    SkillModel(icon: FontAwesomeIcons.webflow, name: 'Web Dev'),
    SkillModel(icon: Icons.no_photography, name: 'Graphic'),
    SkillModel(icon: Icons.adobe, name: 'Adobe Ph'),
    SkillModel(icon: Icons.adobe, name: 'Adobe Pr'),
    SkillModel(icon: Icons.facebook, name: 'Facebook Ads'),
    SkillModel(icon: Icons.shopify, name: 'Shopify'),
    SkillModel(icon: Icons.tiktok, name: 'Tiktok Ads'),
  ];
}
