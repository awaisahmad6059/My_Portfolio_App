class GithubRepoModel {
  final String name;
  final String? description;
  final String? language;
  final int stars;
  final int forks;
  final DateTime updatedAt;
  final String visibility;
  final String htmlUrl;

  const GithubRepoModel({
    required this.name,
    this.description,
    this.language,
    required this.stars,
    required this.forks,
    required this.updatedAt,
    required this.visibility,
    required this.htmlUrl,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      language: json['language'] as String?,
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      visibility: json['visibility'] as String? ?? 'public',
      htmlUrl: json['html_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'language': language,
    'stargazers_count': stars,
    'forks_count': forks,
    'updated_at': updatedAt.toIso8601String(),
    'visibility': visibility,
    'html_url': htmlUrl,
  };

  String get updatedAtFormatted {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
