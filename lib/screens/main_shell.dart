import 'package:flutter/material.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/screens/home/home_screen.dart';
import 'package:aak/screens/projects/projects_screen.dart';
import 'package:aak/screens/about/about_screen.dart';
import 'package:aak/screens/contact/contact_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeScreen(),
    const ProjectsScreen(),
    AboutScreen(onNavigateToTab: (index) => setState(() => _currentIndex = index)),
    const ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(_pages.length, (index) {
          return AnimatedOpacity(
            opacity: _currentIndex == index ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: _currentIndex != index,
              child: _pages[index],
            ),
          );
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bottomNavBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSm,
              vertical: AppDimens.paddingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final isSelected = _currentIndex == index;
                return _NavItem(
                  icon: _icons[index],
                  label: _labels[index],
                  isSelected: isSelected,
                  onTap: () => setState(() => _currentIndex = index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  static const List<IconData> _icons = [
    Icons.home,
    Icons.code,
    Icons.person,
    Icons.contacts,
  ];

  static const List<String> _labels = [
    AppStrings.home,
    AppStrings.projects,
    AppStrings.aboutMe,
    AppStrings.contact,
  ];
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _pulseController.forward().then((_) => _pulseController.reverse());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.bottomNavSelected.withValues(alpha: 0.12)
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      size: 24,
                      color: widget.isSelected
                          ? AppColors.bottomNavSelected
                          : AppColors.bottomNavUnselected,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isSelected
                            ? AppColors.bottomNavSelected
                            : AppColors.bottomNavUnselected,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
