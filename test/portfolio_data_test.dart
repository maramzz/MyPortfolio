import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_portfolio/data/github_repositories_api.dart';
import 'package:my_portfolio/data/portfolio_store.dart';
import 'package:my_portfolio/models/portfolio_project.dart';
import 'package:my_portfolio/models/portfolio_skill.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'Project and skill CRUD changes persist after reloading the store',
    () async {
      final store = PortfolioStore();
      await store.load();

      final project = PortfolioProject(
        id: 'local-project',
        name: 'Local project',
        technologies: 'Dart',
        description: 'A locally managed project.',
        category: 'Personal',
      );
      await store.addProject(project);
      await store.updateProject(
        PortfolioProject(
          id: project.id,
          name: 'Updated project',
          technologies: project.technologies,
          description: project.description,
          category: project.category,
        ),
      );

      final skill = PortfolioSkill(
        id: 'local-skill',
        name: 'Testing',
        technologies: 'Flutter test',
      );
      await store.addSkill(skill);
      await store.updateSkill(
        const PortfolioSkill(
          id: 'local-skill',
          name: 'Automated testing',
          technologies: 'Flutter test',
        ),
      );
      await store.deleteProject('skillup');
      await store.deleteSkill('programming');
      store.dispose();

      final reloadedStore = PortfolioStore();
      await reloadedStore.load();
      expect(
        reloadedStore.projects.map((project) => project.name),
        contains('Updated project'),
      );
      expect(
        reloadedStore.projects.map((project) => project.id),
        isNot(contains('skillup')),
      );
      expect(
        reloadedStore.skills.map((skill) => skill.name),
        contains('Automated testing'),
      );
      expect(
        reloadedStore.skills.map((skill) => skill.id),
        isNot(contains('programming')),
      );
      reloadedStore.dispose();
    },
  );

  test(
    'GitHub API returns typed repositories from the REST response',
    () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'api.github.com');
        expect(request.url.path, '/users/maramzz/repos');
        return http.Response(
          jsonEncode([
            {
              'name': 'PortfolioDemo',
              'html_url': 'https://github.com/maramzz/PortfolioDemo',
              'description': 'A portfolio demo repository.',
              'language': 'Dart',
              'stargazers_count': 3,
            },
          ]),
          200,
        );
      });
      final api = GithubRepositoriesApi(client: client);

      final repositories = await api.fetchRepositories();

      expect(repositories, hasLength(1));
      expect(repositories.single.name, 'PortfolioDemo');
      expect(repositories.single.language, 'Dart');
      expect(repositories.single.stars, 3);
      expect(
        repositories.single.url.toString(),
        'https://github.com/maramzz/PortfolioDemo',
      );
      api.close();
    },
  );

  test('GitHub API reports HTTP failures', () async {
    final api = GithubRepositoriesApi(
      client: MockClient((_) async => http.Response('rate limited', 403)),
    );

    await expectLater(
      api.fetchRepositories(),
      throwsA(
        isA<GithubApiException>().having(
          (error) => error.message,
          'message',
          contains('403'),
        ),
      ),
    );
    api.close();
  });
}
