import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/main.dart';
import 'package:my_portfolio/pages/portfolio_page.dart';
import 'package:my_portfolio/pages/projects_page.dart';
import 'package:my_portfolio/theme/app_theme.dart';

void main() {
  testWidgets('Portfolio app starts on the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('MyPortfolio'))).brightness,
      Brightness.light,
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 50));

    final logoOpacity = tester
        .widget<FadeTransition>(find.byKey(const ValueKey('splash-logo-fade')))
        .opacity
        .value;
    expect(logoOpacity, greaterThan(0));

    final logoOffset = tester
        .widget<SlideTransition>(
          find.byKey(const ValueKey('splash-logo-slide')),
        )
        .position
        .value;
    expect(logoOffset.dy, greaterThan(0));

    await tester.pump(const Duration(milliseconds: 700));
    final settledLogoOffset = tester
        .widget<SlideTransition>(
          find.byKey(const ValueKey('splash-logo-slide')),
        )
        .position
        .value;
    expect(settledLogoOffset.dy, closeTo(0, 0.01));
  });

  testWidgets('Reload returns to home in light mode from a pushed page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    expect(find.byType(Switch), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final titleContext = tester.element(find.text('MyPortfolio'));
    expect(Theme.of(titleContext).brightness, Brightness.dark);

    Navigator.of(titleContext).pushNamed('/skills');
    await tester.pumpAndSettle();
    expect(find.text('Technical Skills'), findsNWidgets(2));

    tester.state<MyAppState>(find.byType(MyApp)).resetForReload();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Hello, I’m'), findsOneWidget);
    expect(find.text('Technical Skills'), findsNothing);
    expect(
      Theme.of(tester.element(find.text('MyPortfolio'))).brightness,
      Brightness.light,
    );
  });

  testWidgets('Repeated app restarts reach the home page', (
    WidgetTester tester,
  ) async {
    for (var i = 0; i < 3; i++) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byTooltip('Open navigation'), findsOneWidget);
      expect(
        Theme.of(tester.element(find.text('MyPortfolio'))).brightness,
        Brightness.light,
      );
    }
  });

  testWidgets('Portfolio cards have no shadow in either theme', (
    WidgetTester tester,
  ) async {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: PortfolioCard(child: Text('Card content')),
          ),
        ),
      );

      final card = tester.widget<Material>(
        find
            .ancestor(
              of: find.text('Card content'),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(card.elevation, 0);
    }
  });

  testWidgets(
    'GitHub project cards are tappable and CampusFind is in progress',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const ProjectsPage()),
      );

      expect(find.text('Work in progress'), findsOneWidget);
      final projectCards = tester
          .widgetList<PortfolioCard>(find.byType(PortfolioCard))
          .toList();
      expect(projectCards, hasLength(3));
      expect(projectCards[0].onTap, isNotNull);
      expect(projectCards[1].onTap, isNotNull);
      expect(projectCards[2].onTap, isNull);
    },
  );
}
