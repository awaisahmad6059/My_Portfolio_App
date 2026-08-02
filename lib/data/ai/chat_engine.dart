import 'package:aak/core/constants/chat_strings.dart';
import 'package:aak/data/ai/chat_intent.dart';
import 'package:aak/data/knowledge_base.dart';

/// Pure rule-based NLP engine for the offline AI chat assistant.
///
/// The engine never makes network calls, never loads a model, and only
/// answers questions that map to one of the known intents. Anything unrelated
/// is answered with the polite [ChatStrings.refusalMessage].
class ChatEngine {
  const ChatEngine();

  /// Replies to a single user [question] with a plain-text answer.
  String answer(String question) {
    final intent = detect(question);

    if (intent == ChatIntent.outOfScope) {
      return ChatStrings.refusalMessage;
    }
    if (intent == ChatIntent.notFound) {
      return ChatStrings.notFoundMessage;
    }

    return _buildResponse(intent, question);
  }

  /// Maps a free-text question to the best-matching [ChatIntent].
  ChatIntent detect(String question) {
    final words = normalize(question);
    if (words.isEmpty) return ChatIntent.notFound;

    for (final entry in kIntentRules.entries) {
      final rule = entry.value;
      if (_matches(rule, words)) return entry.key;
    }

    return ChatIntent.notFound;
  }

  /// Normalizes a question into a stable list of lowercase words.
  List<String> normalize(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return const [];

    // Convert common chat shorthand so the matcher works reliably.
    final expanded = lower
        .replaceAll('r u', 'are you')
        .replaceAll("what's", 'what is')
        .replaceAll("whats", 'what is')
        .replaceAll("who's", 'who is')
        .replaceAll("whos", 'who is')
        .replaceAll("don't", 'do not')
        .replaceAll("can't", 'cannot')
        .replaceAll('&', ' and ');

    final noPunctuation = expanded
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (noPunctuation.isEmpty) return const [];
    return noPunctuation.split(' ');
  }

  bool _matches(IntentRule rule, List<String> words) {
    bool groupMatches = false;
    for (final group in rule.groups) {
      for (final term in group) {
        if (_containsPhrase(words, term)) {
          groupMatches = true;
          break;
        }
      }
      if (groupMatches) break;
    }

    if (!groupMatches) return false;

    if (rule.requiresContext) {
      return rule.context.any((term) => _containsPhrase(words, term));
    }
    return true;
  }

  bool _containsPhrase(List<String> words, String phrase) {
    final phraseWords = phrase.split(' ');
    for (var i = 0; i + phraseWords.length <= words.length; i++) {
      var match = true;
      for (var j = 0; j < phraseWords.length; j++) {
        if (words[i + j] != phraseWords[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  String _buildResponse(ChatIntent intent, String question) {
    switch (intent) {
      case ChatIntent.greeting:
        final hour = DateTime.now().hour;
        if (hour < 12) return 'Assalam-o-Alaikum! Good morning! How can I help you?';
        if (hour < 17) return 'Assalam-o-Alaikum! Good afternoon! How can I help you?';
        return 'Assalam-o-Alaikum! Good evening! How can I help you?';

      case ChatIntent.assistantIdentity:
        return ChatStrings.assistantIdentity;

      case ChatIntent.whoIs:
      case ChatIntent.about:
        return '${KnowledgeBase.name} (also known as ${KnowledgeBase.aka}) is a '
            '${KnowledgeBase.title} and ${KnowledgeBase.altTitle} based in '
            '${KnowledgeBase.location}. He has ${KnowledgeBase.experienceSummary} of '
            'experience and has built ${KnowledgeBase.projects.fold<int>(0, (sum, c) => sum + c.projects.length)} '
            'projects across mobile apps, web apps, games, e-commerce, and '
            'AI-powered applications. His career objective: ${KnowledgeBase.careerObjective}';

      case ChatIntent.name:
        return 'His name is ${KnowledgeBase.name}, also known by the initials '
            '${KnowledgeBase.aka}.';

      case ChatIntent.services:
        final services = KnowledgeBase.services
            .map((s) => '- ${s.title}: ${s.description}')
            .join('\n');
        return 'Here are the services ${KnowledgeBase.name} offers:\n$services\n\n'
            'If you want to hire him, I can share his contact details.';

      case ChatIntent.skills:
        final skills = KnowledgeBase.skills
            .map((s) => '- ${s.name}')
            .join('\n');
        return '${KnowledgeBase.name} is skilled in:\n$skills\n\n'
            'His top strengths are ${KnowledgeBase.strengths.take(3).join(', ')}.';

      case ChatIntent.education:
        final edu = KnowledgeBase.education;
        return 'He completed a ${edu.degree} from ${edu.institution} '
            '(${edu.period}). Key coursework included '
            '${edu.coursework.take(4).join(', ')}, and more.';

      case ChatIntent.experience:
        return '${KnowledgeBase.name} has ${KnowledgeBase.experienceSummary} of '
            'experience as a Software Developer and Mobile Application '
            'Developer. He has worked on Android (Kotlin & Java), Flutter, '
            'web development, and AI-powered apps, and has published 20+ '
            'applications on the Google Play Store.';

      case ChatIntent.projects:
        final groups = KnowledgeBase.projects;
        final buffer = StringBuffer();
        for (final group in groups) {
          buffer.writeln('* ${group.name}: ${group.projects.take(6).join(', ')}'
              '${group.projects.length > 6 ? ', and more' : ''}');
        }
        return 'Here is an overview of his projects (${groups.fold<int>(0, (s, g) => s + g.projects.length)} total):\n$buffer';

      case ChatIntent.projectCategories:
        final categories = KnowledgeBase.projects
            .map((c) => '- ${c.name}: ${c.description}')
            .join('\n');
        return 'His projects fall into these categories:\n$categories';

      case ChatIntent.techStack:
        return 'He works with: Flutter, Android (Kotlin & Java), Dart, React, '
            'React Native, Firebase, Google Gemini AI, Web Development, and '
            'UI/UX Design.';

      case ChatIntent.tools:
        return 'He uses tools like Android Studio, Flutter/Dart, Firebase, '
            'Adobe Photoshop, Adobe Premiere Pro, GitHub, and Shopify.';

      case ChatIntent.languages:
        final languages = KnowledgeBase.languages
            .map((l) => '- ${l.name} (${l.proficiency})')
            .join('\n');
        return 'He can communicate in:\n$languages';

      case ChatIntent.achievements:
        final achievements = KnowledgeBase.achievements
            .map((a) => '- $a')
            .join('\n');
        return 'Some of his achievements:\n$achievements';

      case ChatIntent.certifications:
        final certifications = KnowledgeBase.certifications
            .map((c) => '- $c')
            .join('\n');
        return 'His certifications include:\n$certifications';

      case ChatIntent.strengths:
        final strengths = KnowledgeBase.strengths
            .map((s) => '- $s')
            .join('\n');
        return 'His key strengths are:\n$strengths';

      case ChatIntent.careerObjective:
        return KnowledgeBase.careerObjective;

      case ChatIntent.location:
        return '${KnowledgeBase.name} is based in ${KnowledgeBase.location}.';

      case ChatIntent.contactEmail:
        return 'You can reach him at ${KnowledgeBase.contact.email}.';

      case ChatIntent.contactPhone:
        return 'You can call or WhatsApp him at ${KnowledgeBase.contact.phone} '
            '(${KnowledgeBase.contact.whatsappLink}).';

      case ChatIntent.contactSocial:
        final socials = KnowledgeBase.socials
            .map((s) => '- ${s.platform}: ${s.url}')
            .join('\n');
        return 'You can follow him here:\n$socials';

      case ChatIntent.resume:
        return 'You can view his resume here: ${KnowledgeBase.contact.resumeUrl}';

      case ChatIntent.howToHire:
        return 'To work with ${KnowledgeBase.name}, you can contact him at '
            '${KnowledgeBase.contact.email} or call/WhatsApp him at '
            '${KnowledgeBase.contact.phone}. You can also view his resume: '
            '${KnowledgeBase.contact.resumeUrl}';

      case ChatIntent.thanks:
        return 'You are most welcome! If you have any other questions about '
            '${KnowledgeBase.name}, feel free to ask.';

      case ChatIntent.yes:
        return 'Great! Ask me anything about ${KnowledgeBase.name}, his projects, '
            'skills, or services.';

      case ChatIntent.no:
        return 'No problem! Just type a question whenever you need it.';

      case ChatIntent.goodbye:
        return 'Goodbye! It was nice talking to you. Feel free to come back '
            'anytime.';

      case ChatIntent.outOfScope:
      case ChatIntent.notFound:
        return ChatStrings.refusalMessage;
    }
  }
}
