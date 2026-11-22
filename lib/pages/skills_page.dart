import 'package:flutter/material.dart';

import '../data/portfolio_store.dart';
import '../models/portfolio_skill.dart';
import '../widgets/skill_editor_dialog.dart';
import 'portfolio_page.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PortfolioStoreScope.of(context);
    final colors = Theme.of(context).colorScheme;

    return PortfolioPage(
      title: 'Technical Skills',
      label: 'WHAT I WORK WITH',
      currentRoute: '/skills',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: store.isReady && !store.isSaving
            ? () => _editSkill(context, store)
            : null,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add skill'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technologies and tools I have studied or used in coursework and development projects.',
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.7),
          ),
          const SizedBox(height: 28),
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
          else if (store.skills.isEmpty)
            const PortfolioLoadNotice(
              message: 'No skills yet. Add one to get started.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 680 ? 2 : 1;
                final cardWidth = columns == 2
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (var index = 0; index < store.skills.length; index++)
                      SizedBox(
                        width: cardWidth,
                        child: _SkillCard(
                          skill: store.skills[index],
                          index: index,
                          isSaving: store.isSaving,
                          onEdit: () =>
                              _editSkill(context, store, store.skills[index]),
                          onDelete: () =>
                              _deleteSkill(context, store, store.skills[index]),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _editSkill(
    BuildContext context,
    PortfolioStore store, [
    PortfolioSkill? current,
  ]) async {
    final skill = await showDialog<PortfolioSkill>(
      context: context,
      builder: (_) => SkillEditorDialog(skill: current),
    );
    if (skill == null || !context.mounted) return;

    try {
      if (current == null) {
        await store.addSkill(skill);
      } else {
        await store.updateSkill(skill);
      }
    } catch (error) {
      if (context.mounted) _showError(context, 'Could not save skill: $error');
    }
  }

  Future<void> _deleteSkill(
    BuildContext context,
    PortfolioStore store,
    PortfolioSkill skill,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete skill?'),
            content: Text('Remove "${skill.name}" from your portfolio?'),
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
    if (!shouldDelete || !context.mounted) return;

    try {
      await store.deleteSkill(skill.id);
    } catch (error) {
      if (context.mounted) {
        _showError(context, 'Could not delete skill: $error');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.skill,
    required this.index,
    required this.isSaving,
    required this.onEdit,
    required this.onDelete,
  });

  final PortfolioSkill skill;
  final int index;
  final bool isSaving;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PortfolioCard(
      key: ValueKey('skill-${skill.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Edit ${skill.name}',
                onPressed: isSaving ? null : onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete ${skill.name}',
                onPressed: isSaving ? null : onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            skill.name,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            skill.technologies,
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.6),
          ),
        ],
      ),
    );
  }
}
