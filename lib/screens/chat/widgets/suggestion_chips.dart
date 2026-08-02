import 'package:flutter/material.dart';
import 'package:aak/core/constants/chat_strings.dart';
import 'package:aak/screens/chat/chat_palette.dart';

/// Horizontally scrollable suggested prompt chips. Tapping one sends it.
class SuggestionChips extends StatelessWidget {
  final ChatPalette palette;
  final ValueChanged<String> onSuggestionTap;

  const SuggestionChips({
    super.key,
    required this.palette,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ChatStrings.suggestionsHeading,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ChatStrings.suggestedPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = ChatStrings.suggestedPrompts[index];
                return ActionChip(
                  label: Text(
                    prompt,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  backgroundColor: palette.chipBackground,
                  side: BorderSide(color: palette.chipBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => onSuggestionTap(prompt),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
