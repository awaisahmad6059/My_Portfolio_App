class GithubUserModel {
  final String login;
  final int publicRepos;
  final int followers;
  final int following;

  const GithubUserModel({
    required this.login,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GithubUserModel.fromJson(Map<String, dynamic> json) {
    return GithubUserModel(
      login: json['login'] as String? ?? '',
      publicRepos: json['public_repos'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
    );
  }
}
