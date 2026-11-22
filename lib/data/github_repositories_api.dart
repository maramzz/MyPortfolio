import 'dart:convert';

import 'package:http/http.dart' as http;

class GithubRepository {
  const GithubRepository({
    required this.name,
    required this.url,
    required this.description,
    required this.language,
    required this.stars,
  });

  final String name;
  final Uri url;
  final String? description;
  final String? language;
  final int? stars;
}

class GithubRepositoriesApi {
  GithubRepositoriesApi({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<GithubRepository>> fetchRepositories() async {
    final response = await _client
        .get(
          Uri.https('api.github.com', '/users/maramzz/repos', {
            'sort': 'updated',
            'per_page': '6',
          }),
          headers: const {'Accept': 'application/vnd.github+json'},
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw GithubApiException(
        'GitHub returned status ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const GithubApiException('GitHub returned an invalid response.');
    }

    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const GithubApiException(
              'GitHub returned an invalid repository.',
            );
          }
          final name = item['name'];
          final htmlUrl = item['html_url'];
          final description = item['description'];
          final language = item['language'];
          final stars = item['stargazers_count'];
          final repositoryUri = htmlUrl is String
              ? Uri.tryParse(htmlUrl)
              : null;
          if (name is! String ||
              repositoryUri == null ||
              repositoryUri.scheme != 'https' ||
              repositoryUri.host != 'github.com') {
            throw const GithubApiException(
              'GitHub returned an invalid repository.',
            );
          }
          return GithubRepository(
            name: name,
            url: repositoryUri,
            description: description is String && description.isNotEmpty
                ? description
                : null,
            language: language is String ? language : null,
            stars: stars is int ? stars : null,
          );
        })
        .toList(growable: false);
  }

  void close() => _client.close();
}

class GithubApiException implements Exception {
  const GithubApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
