import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aak/core/constants/chat_strings.dart';
import 'package:aak/data/ai/chat_engine.dart';
import 'package:aak/models/chat_message.dart';

/// The chat provider exposes the message list, the typing indicator state,
/// suggested prompts, and the chat screen's dark/light mode (persisted via
/// shared_preferences). It drives the whole AI assistant tab.
class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final bool isDarkMode;

  const ChatState({
    required this.messages,
    required this.isTyping,
    required this.isDarkMode,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    bool? isDarkMode,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

const String _themePrefKey = 'chat_dark_mode';

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return const ChatState(
      messages: [
        ChatMessage(
          role: ChatRole.assistant,
          text: ChatStrings.welcomeMessage,
          timestamp: null,
        ),
      ],
      isTyping: false,
      isDarkMode: true,
    );
  }

  /// Loads the persisted chat theme preference once the screen appears.
  Future<void> restoreThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool(_themePrefKey) ?? true;
    if (dark != state.isDarkMode) {
      state = state.copyWith(isDarkMode: dark);
    }
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, newValue);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(role: ChatRole.user, text: trimmed, timestamp: DateTime.now()),
      ],
      isTyping: true,
    );

    // Small delay so the typing indicator is actually visible.
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final reply = const ChatEngine().answer(trimmed);

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          role: ChatRole.assistant,
          text: reply,
          timestamp: DateTime.now(),
        ),
      ],
      isTyping: false,
    );
  }

  void clearChat() {
    state = state.copyWith(
      messages: [
        ChatMessage(
          role: ChatRole.assistant,
          text: ChatStrings.welcomeMessage,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }
}

final chatStateProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
