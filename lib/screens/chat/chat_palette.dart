import 'package:flutter/material.dart';

/// Color palette for the AI chat screen. The chat has its own light/dark
/// palette so the rest of the app stays untouched.
@immutable
class ChatPalette {
  final Color background;
  final Color surface;
  final Color appBarBackground;
  final Color assistantBubble;
  final Color userBubble;
  final Color textPrimary;
  final Color textSecondary;
  final Color inputBackground;
  final Color inputBorder;
  final Color chipBackground;
  final Color chipBorder;
  final Color onlineDot;
  final Color divider;

  const ChatPalette({
    required this.background,
    required this.surface,
    required this.appBarBackground,
    required this.assistantBubble,
    required this.userBubble,
    required this.textPrimary,
    required this.textSecondary,
    required this.inputBackground,
    required this.inputBorder,
    required this.chipBackground,
    required this.chipBorder,
    required this.onlineDot,
    required this.divider,
  });

  static const ChatPalette dark = ChatPalette(
    background: Color(0xFF000000),
    surface: Color(0xFF101010),
    appBarBackground: Color(0xFF0D0D0D),
    assistantBubble: Color(0xFF1F1F1F),
    userBubble: Color(0xFF2F6FED),
    textPrimary: Color(0xFFF5F5F7),
    textSecondary: Color(0xFF9E9E9E),
    inputBackground: Color(0xFF141414),
    inputBorder: Color(0xFF2A2A2A),
    chipBackground: Color(0xFF1A1A1A),
    chipBorder: Color(0xFF333333),
    onlineDot: Color(0xFF34C759),
    divider: Color(0xFF1F1F1F),
  );

  static const ChatPalette light = ChatPalette(
    background: Color(0xFFF6F6F7),
    surface: Color(0xFFFFFFFF),
    appBarBackground: Color(0xFFFFFFFF),
    assistantBubble: Color(0xFFFFFFFF),
    userBubble: Color(0xFF2F6FED),
    textPrimary: Color(0xFF1C1C1E),
    textSecondary: Color(0xFF636366),
    inputBackground: Color(0xFFFFFFFF),
    inputBorder: Color(0xFFE5E5EA),
    chipBackground: Color(0xFFFFFFFF),
    chipBorder: Color(0xFFD9D9DE),
    onlineDot: Color(0xFF34C759),
    divider: Color(0xFFECECEF),
  );
}
