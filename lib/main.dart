import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/routes/app_routes.dart';
import 'package:aak/core/theme/app_theme.dart';
import 'package:aak/screens/main_shell.dart';
import 'package:aak/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );
          case AppRoutes.home:
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const MainShell(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeIn,
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            );
          default:
            return null;
        }
      },
    );
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}
