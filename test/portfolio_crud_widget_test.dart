import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_portfolio/data/github_repositories_api.dart';
import 'package:my_portfolio/data/portfolio_store.dart';
import 'package:my_portfolio/pages/projects_page.dart';
import 'package:my_portfolio/pages/skills_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Projects can be added, edited, and deleted from the UI', (
    tester,
  ) async {
    final store = PortfolioStore();
    await store.load();
    addTearDown(store.dispose);

    await tester.pumpWidget(
      MaterialApp(
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

    await tester.tap(find.text('Add project'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Test project');
    await tester.enterText(find.byType(TextFormField).at(1), 'Flutter');
    await tester.enterText(find.byType(TextFormField).at(2), 'A test project.');
    await tester.enterText(find.byType(TextFormField).at(3), 'Personal');
    await tester.tap(find.text('Add project').last);
    await tester.pumpAndSettle();
    expect(find.text('Test project'), findsOneWidget);

    final editProject = find.byTooltip('Edit Test project');
    await tester.ensureVisible(editProject);
    await tester.tap(editProject);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Updated test project',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Updated test project'), findsOneWidget);

    final deleteProject = find.byTooltip('Delete Updated test project');
    await tester.ensureVisible(deleteProject);
    await tester.tap(deleteProject);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Updated test project'), findsNothing);
  });

  testWidgets('Skills can be added, edited, and deleted from the UI', (
    tester,
  ) async {
    final store = PortfolioStore();
    await store.load();
    addTearDown(store.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: PortfolioStoreScope(store: store, child: const SkillsPage()),
      ),
    );

    await tester.tap(find.text('Add skill'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Test category');
    await tester.enterText(find.byType(TextFormField).at(1), 'Dart');
    await tester.tap(find.text('Add skill').last);
    await tester.pumpAndSettle();
    expect(find.text('Test category'), findsOneWidget);

    final editSkill = find.byTooltip('Edit Test category');
    await tester.ensureVisible(editSkill);
    await tester.tap(editSkill);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Updated category',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Updated category'), findsOneWidget);

    final deleteSkill = find.byTooltip('Delete Updated category');
    await tester.ensureVisible(deleteSkill);
    await tester.tap(deleteSkill);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Updated category'), findsNothing);
  });

  testWidgets('GitHub API errors are shown and can be retried', (tester) async {
    final store = PortfolioStore();
    await store.load();
    addTearDown(store.dispose);
    var requestCount = 0;
    final api = GithubRepositoriesApi(
      client: MockClient((_) async {
        requestCount++;
        if (requestCount == 1) return http.Response('rate limited', 403);
        return http.Response('[]', 200);
      }),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PortfolioStoreScope(
          store: store,
          child: ProjectsPage(githubApi: api),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Live GitHub details are unavailable'),
      findsOneWidget,
    );
    final retry = find.text('Retry');
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(
      find.text('No public GitHub repositories were found.'),
      findsNothing,
    );
    expect(
      find.text(
        'A React web app to organise learning resources and study tasks, built for my Frameworks Web course.',
      ),
      findsOneWidget,
    );
    expect(requestCount, 2);
  });

  testWidgets('Live GitHub details update the matching project card', (
    tester,
  ) async {
    final store = PortfolioStore();
    await store.load();
    addTearDown(store.dispose);
    final api = GithubRepositoriesApi(
      client: MockClient(
        (_) async => http.Response('''
          [
            {
              "name": "SkillUp",
              "html_url": "https://github.com/maramzz/SkillUp",
              "description": "Live description from GitHub.",
              "language": "JavaScript",
              "stargazers_count": 7
            }
          ]
          ''', 200),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PortfolioStoreScope(
          store: store,
          child: ProjectsPage(githubApi: api),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Live description from GitHub.'), findsOneWidget);
    expect(
      find.text(
        'A React web app to organise learning resources and study tasks, built for my Frameworks Web course.',
      ),
      findsNothing,
    );
    expect(find.text('JavaScript'), findsOneWidget);
    expect(find.text('7 stars'), findsOneWidget);
    expect(find.text('GitHub repositories'), findsNothing);
  });
}
