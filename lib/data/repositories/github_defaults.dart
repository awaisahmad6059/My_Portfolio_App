import 'package:aak/models/github_repo_model.dart';
import 'package:aak/models/github_user_model.dart';

final _repoNames = [
  "Event_Budget_Planner", "My_Portfolio_App", "Car_race_game",
  "ballon_pop_game", "tip_calculator", "smart_billing_pos_system",
  "Color_Match_Game", "Ludo_Royale", "Quotes_Saver",
  "ai_pet_companion_pro", "CleanParagrapgh", "UnitCalculator",
  "NotePAdWithDArkmodeandPIN", "ExpensTracker", "OrderManagement",
  "awaisahmad6059", "ToDoList", "alarm",
  "FancyNicknameGenerator", "TasbehCounterapp", "TICTACDuel",
  "RemotePresence", "NotePad", "SmartKit",
  "Al-Tabreed", "StickyNotesaak", "PortfolioWeb",
  "Tictactoe", "Socialmediaapp", "CMS",
  "portfolio", "aichatbox", "Portfolio-with-AIChatBox",
  "StickyNotes", "E_CommereceED",
];

GithubUserModel defaultGithubUser() => GithubUserModel.fromJson({
  "login": "awaisahmad6059",
  "public_repos": 35,
  "followers": 2,
  "following": 0,
});

List<GithubRepoModel> defaultGithubRepos() {
  final now = DateTime.now().toIso8601String();
  return _repoNames.map((name) => GithubRepoModel.fromJson({
    "name": name,
    "description": "",
    "language": null,
    "stargazers_count": 0,
    "forks_count": 0,
    "updated_at": now,
    "visibility": "public",
    "html_url": "https://github.com/awaisahmad6059/$name",
  })).toList();
}
