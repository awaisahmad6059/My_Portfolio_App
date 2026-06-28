import 'package:flutter/material.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';

class ContactActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ContactActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<ContactActionCard> createState() => _ContactActionCardState();
}

class _ContactActionCardState extends State<ContactActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: AppDimens.buttonWidth,
              height: AppDimens.buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: AppColors.white,
                    size: AppDimens.iconLarge,
                  ),
                  const SizedBox(height: AppDimens.paddingSm),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppDimens.fontSm,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
