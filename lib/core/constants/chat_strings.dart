/// Static strings used by the AI chat assistant feature.
class ChatStrings {
  ChatStrings._();

  static const String chatTitle = 'AI Assistant';
  static const String chatSubtitle = "Awais Ahmad's Personal AI Assistant";
  static const String offlineBadge = 'Offline';

  static const String inputHint = 'Ask about Awais...';

  static const String welcomeMessage =
      "Assalam-o-Alaikum! I'm Awais Ahmad's Personal AI Assistant. I can "
      'answer questions about Awais, his education, skills, projects, '
      'services, experience, achievements, certifications, and contact '
      'information. What would you like to know?';

  static const String emptyInput = 'Please type a question about Awais Ahmad.';

  /// Exact refusal reply used when a question is unrelated to Awais Ahmad.
  static const String refusalMessage =
      "I'm Awais Ahmad's Personal AI Assistant. I can only answer questions "
      'related to Awais Ahmad, his portfolio, projects, skills, experience, '
      'services, and contact information. Please ask a question related to '
      'Awais Ahmad.';

  /// Reply used when a question is about Awais but the information is unknown.
  static const String notFoundMessage =
      "I don't have information about that yet. You can ask me about Awais's "
      'skills, projects, education, experience, services, or contact details.';

  /// Reply used when the user asks who or what the assistant is.
  static const String assistantIdentity =
      "I'm Awais Ahmad's Personal AI Assistant, built into his portfolio app. "
      'I run completely offline on your device and can only answer questions '
      'related to Awais Ahmad and his work. I am not an online AI or ChatGPT.';

  static const String clearChat = 'Clear chat';
  static const String lightMode = 'Switch to light mode';
  static const String darkMode = 'Switch to dark mode';

  static const String suggestionsHeading = 'Try asking:';

  static const List<String> suggestedPrompts = [
    'Who is Awais Ahmad?',
    'What are his skills?',
    'Tell me about his education',
    'What projects has he built?',
    'What services does he offer?',
    'How can I contact him?',
  ];
}
