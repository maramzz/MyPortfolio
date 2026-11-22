import 'dart:async';

import 'package:flutter/material.dart';

import 'pages/contact_page.dart';
import 'pages/about_page.dart';
import 'pages/experience_page.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/skills_page.dart';
import 'splash_screen.dart';
import 'data/portfolio_store.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late final ThemeModeController _themeController;
  late final PortfolioStore _portfolioStore;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _startAtHome = false;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeModeController();
    _portfolioStore = PortfolioStore();
    unawaited(_portfolioStore.load());
  }

  @override
  void dispose() {
    _themeController.dispose();
    _portfolioStore.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    resetForReload();
    super.reassemble();
  }

  @visibleForTesting
  void resetForReload() {
    setState(() {
      _themeController.setDarkMode(false);
      _startAtHome = true;
      _navigatorKey = GlobalKey<NavigatorState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'My Portfolio',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeController.mode,
          builder: (context, child) => PortfolioStoreScope(
            store: _portfolioStore,
            child: ThemeModeScope(
              controller: _themeController,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          home: _startAtHome ? const HomePage() : const SplashScreen(),
          onGenerateRoute: _generateRoute,
        );
      },
    );
  }
}

Route<void> _generateRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case '/about':
      page = const AboutPage();
      break;
    case '/skills':
      page = const SkillsPage();
      break;
    case '/experience':
      page = const ExperiencePage();
      break;
    case '/projects':
      page = const ProjectsPage();
      break;
    case '/contact':
      page = const ContactPage();
      break;
    default:
      page = const SplashScreen();
  }

  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (context, animation, _, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;

      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.035, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
