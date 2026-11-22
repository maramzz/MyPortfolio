import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/github_repositories_api.dart';
import '../data/portfolio_store.dart';
import '../models/portfolio_project.dart';
import '../widgets/project_editor_dialog.dart';
import 'portfolio_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, this.githubApi});

  final GithubRepositoriesApi? githubApi;

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late final GithubRepositoriesApi _githubApi;
  late Future<List<GithubRepository>> _repositories;

  @override
  void initState() {
    super.initState();
    _githubApi = widget.githubApi ?? GithubRepositoriesApi();
    _repositories = _githubApi.fetchRepositories();
  }

  @override
  void dispose() {
    _githubApi.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = PortfolioStoreScope.of(context);
    final colors = Theme.of(context).colorScheme;

    return PortfolioPage(
      title: 'Work',
      label: 'SELECTED WORK',
      currentRoute: '/projects',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: store.isReady && !store.isSaving
            ? () => _editProject(store)
            : null,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add project'),
      ),
      child: FutureBuilder<List<GithubRepository>>(
        future: _repositories,
        builder: (context, snapshot) {
          final repositoriesByName = {
            for (final repository in snapshot.data ?? <GithubRepository>[])
              repository.name.toLowerCase(): repository,
          };
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects and coursework. Tap a project to open its repository.',
                style: TextStyle(color: colors.onSurfaceVariant, height: 1.6),
              ),
              const SizedBox(height: 20),
              if (isLoading) ...[
                const Text('Loading live GitHub details…'),
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
                const SizedBox(height: 16),
              ],
              if (store.isLoading)
                const PortfolioLoadNotice(
                  message: 'Loading saved portfolio data…',
                  isLoading: true,
                )
              else if (store.loadError case final error?)
                PortfolioLoadNotice(
                  message: 'Could not load saved portfolio data: $error',
                  onRetry: store.load,
                )
              else if (store.projects.isEmpty)
                const PortfolioLoadNotice(
                  message: 'No projects yet. Add one to get started.',
                )
              else
                for (var index = 0; index < store.projects.length; index++)
                  _buildProjectCard(
                    store,
                    store.projects[index],
                    index,
                    _repositoryFor(store.projects[index], repositoriesByName),
                    isLoading,
                  ),
              if (snapshot.hasError) ...[
                const SizedBox(height: 12),
                PortfolioLoadNotice(
                  message:
                      'Live GitHub details are unavailable. Showing saved project information. ${snapshot.error}',
                  onRetry: () {
                    setState(() {
                      _repositories = _githubApi.fetchRepositories();
                    });
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  GithubRepository? _repositoryFor(
    PortfolioProject project,
    Map<String, GithubRepository> repositoriesByName,
  ) {
    final repositoryUrl = project.repository;
    if (repositoryUrl == null) return null;
    final uri = Uri.tryParse(repositoryUrl);
    if (uri == null || uri.pathSegments.isEmpty) return null;
    return repositoriesByName[uri.pathSegments.last.toLowerCase()];
  }

  Widget _buildProjectCard(
    PortfolioStore store,
    PortfolioProject project,
    int index,
    GithubRepository? liveRepository,
    bool isLoading,
  ) {
    final colors = Theme.of(context).colorScheme;
    final liveDescription = liveRepository?.description?.trim();

    return PortfolioCard(
      key: ValueKey('project-${project.id}'),
      margin: const EdgeInsets.only(bottom: 16),
      onTap: project.repository == null
          ? null
          : () => _openRepository(project.repository!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Edit ${project.name}',
                onPressed: store.isSaving
                    ? null
                    : () => _editProject(store, project),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete ${project.name}',
                onPressed: store.isSaving
                    ? null
                    : () => _deleteProject(store, project),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
              if (project.repository != null)
                Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.technologies,
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  liveDescription == null || liveDescription.isEmpty
                      ? project.description
                      : liveDescription,
                  style: TextStyle(color: colors.onSurfaceVariant, height: 1.6),
                ),
                if (isLoading && project.repository != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Loading live repository details…',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
                if (liveRepository != null &&
                    (liveRepository.language != null ||
                        liveRepository.stars != null)) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (liveRepository.language case final language?)
                        SectionTag(language),
                      if (liveRepository.stars case final stars?)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_outline_rounded,
                              size: 18,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$stars stars',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SectionTag(project.category),
                    if (project.status != null) SectionTag(project.status!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProject(
    PortfolioStore store, [
    PortfolioProject? current,
  ]) async {
    final project = await showDialog<PortfolioProject>(
      context: context,
      builder: (_) => ProjectEditorDialog(project: current),
    );
    if (project == null || !mounted) return;

    try {
      if (current == null) {
        await store.addProject(project);
      } else {
        await store.updateProject(project);
      }
    } catch (error) {
      if (mounted) _showError('Could not save project: $error');
    }
  }

  Future<void> _deleteProject(
    PortfolioStore store,
    PortfolioProject project,
  ) async {
    final shouldDelete = await _confirmDelete(project.name);
    if (!shouldDelete || !mounted) return;
    try {
      await store.deleteProject(project.id);
    } catch (error) {
      if (mounted) _showError('Could not delete project: $error');
    }
  }

  Future<bool> _confirmDelete(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete project?'),
            content: Text('Remove "$name" from your portfolio?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _openRepository(String url) async {
    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) {
        _showError('Could not open this repository.');
      }
    } catch (error) {
      if (mounted) _showError('Could not open this repository: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
