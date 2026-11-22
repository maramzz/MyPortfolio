import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_portfolio/main.dart';
import 'package:my_portfolio/data/github_repositories_api.dart';
import 'package:my_portfolio/data/portfolio_store.dart';
import 'package:my_portfolio/pages/home_page.dart';
import 'package:my_portfolio/pages/portfolio_page.dart';
import 'package:my_portfolio/pages/projects_page.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

  testWidgets('Navigation switches sections and back returns to prior pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skills'));
    await tester.pumpAndSettle();
    expect(find.text('Technical Skills'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About Me'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Technical Skills'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, I’m'), findsOneWidget);
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

  testWidgets('Home ambient background drifts gently', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    final glow = find.byKey(const ValueKey('home-ambient-top-glow'));
    final initialX = tester
        .widget<Transform>(glow)
        .transform
        .getTranslation()
        .x;
    await tester.pump(const Duration(seconds: 2));
    final movedX = tester.widget<Transform>(glow).transform.getTranslation().x;

    expect(movedX, lessThan(initialX));
  });

  testWidgets('Home ambient background stays still with reduced motion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const HomePage(),
          ),
        ),
      ),
    );

    final glow = find.byKey(const ValueKey('home-ambient-top-glow'));
    final initialX = tester
        .widget<Transform>(glow)
        .transform
        .getTranslation()
        .x;
    await tester.pump(const Duration(seconds: 2));
    final finalX = tester.widget<Transform>(glow).transform.getTranslation().x;

    expect(finalX, initialX);
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
      final store = PortfolioStore();
      await store.load();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: PortfolioStoreScope(
            store: store,
            child: ProjectsPage(
              githubApi: GithubRepositoriesApi(
                client: MockClient((_) async => http.Response('[]', 200)),
              ),
            ),
          ),
        ),
      );
      addTearDown(store.dispose);

      expect(find.text('Work in progress'), findsOneWidget);
      expect(find.byKey(const ValueKey('project-skillup')), findsOneWidget);
      expect(find.byKey(const ValueKey('project-campusfind')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('project-telnet-project-management')),
        findsOneWidget,
      );

      final projectCard = find.byKey(const ValueKey('project-skillup'));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: tester.getCenter(projectCard));
      await mouse.moveTo(tester.getCenter(projectCard));
      await tester.pump(const Duration(milliseconds: 200));

      final animatedCard = tester.widget<AnimatedContainer>(
        find.descendant(
          of: projectCard,
          matching: find.byType(AnimatedContainer),
        ),
      );
      await mouse.removePointer();
      expect(
        animatedCard.decoration,
        isA<BoxDecoration>().having(
          (decoration) => decoration.border!.top.color,
          'hover border color',
          AppTheme.light.colorScheme.primary.withAlpha(150),
        ),
      );
    },
  );
}
