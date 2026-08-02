import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/constants/chat_strings.dart';
import 'package:aak/providers/chat_provider.dart';
import 'package:aak/screens/chat/chat_palette.dart';
import 'package:aak/screens/chat/widgets/message_bubble.dart';
import 'package:aak/screens/chat/widgets/suggestion_chips.dart';
import 'package:aak/screens/chat/widgets/typing_indicator.dart';

/// The offline AI assistant tab: a chat with a pure rule-based engine.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(chatStateProvider.notifier).restoreThemePreference();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(String text) {
    final notifier = ref.read(chatStateProvider.notifier);
    if (ref.read(chatStateProvider).isTyping) return;
    _controller.clear();
    FocusScope.of(context).unfocus();
    notifier.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);
    final palette =
        chatState.isDarkMode ? ChatPalette.dark : ChatPalette.light;
    final showSuggestions = chatState.messages.length <= 1 && !chatState.isTyping;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: palette.userBubble.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.smart_toy_outlined, color: palette.userBubble),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ChatStrings.chatTitle,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.onlineDot,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${ChatStrings.offlineBadge} \u00b7 ${ChatStrings.chatSubtitle}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: chatState.isDarkMode
                ? ChatStrings.lightMode
                : ChatStrings.darkMode,
            onPressed: () =>
                ref.read(chatStateProvider.notifier).toggleTheme(),
            icon: Icon(
              chatState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: palette.textPrimary,
            ),
          ),
          IconButton(
            tooltip: ChatStrings.clearChat,
            onPressed: () =>
                ref.read(chatStateProvider.notifier).clearChat(),
            icon: Icon(Icons.delete_outline, color: palette.textPrimary),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  for (final message in chatState.messages.reversed)
                    MessageBubble(message: message, palette: palette),
                  if (chatState.isTyping) TypingIndicator(palette: palette),
                ],
              ),
            ),
            if (showSuggestions)
              SuggestionChips(
                palette: palette,
                onSuggestionTap: _send,
              ),
            _buildInputBar(palette, chatState.isTyping),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(ChatPalette palette, bool isTyping) {
    return Container(
      decoration: BoxDecoration(
        color: palette.appBarBackground,
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _send(value),
              style: TextStyle(color: palette.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: ChatStrings.inputHint,
                hintStyle:
                    TextStyle(color: palette.textSecondary, fontSize: 15),
                filled: true,
                fillColor: palette.inputBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: palette.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: palette.userBubble),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: palette.userBubble,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isTyping ? null : () => _send(_controller.text),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isTyping ? Icons.more_horiz : Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
