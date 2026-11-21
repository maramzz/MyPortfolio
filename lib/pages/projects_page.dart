import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'portfolio_page.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const projects = [
      (
        number: '01',
        name: 'SkillUp',
        technologies: 'React · JavaScript',
        description: 'A React web app to organise learning resources and study tasks, built for my Frameworks Web course.',
        category: 'Course project · 2026',
        status: null,
        repository: 'https://github.com/maramzz/SkillUp',
      ),
      (
        number: '02',
        name: 'CampusFind',
        technologies: 'React · Spring Boot · PostgreSQL · Docker Compose',
        description: 'A campus lost-and-found platform built with Spring Boot microservices.',
        category: 'Personal project',
        status: 'Work in progress',
        repository: 'https://github.com/maramzz/CampusFind',
      ),
      (
        number: '03',
        name: 'Project management app',
        technologies: 'Angular · TypeScript · Spring Boot · PostgreSQL',
        description: 'A project management application developed during my internship at Telnet.',
        category: 'Internship · Telnet',
        status: null,
        repository: null,
      ),
    ];

    return PortfolioPage(
      title: 'Work',
      label: 'SELECTED WORK',
      child: Column(
        children: [
          for (final project in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PortfolioCard(
                onTap: project.repository == null
                    ? null
                    : () => _openRepository(context, project.repository!),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        project.number,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
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
                            project.description,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SectionTag(project.category),
                              if (project.status != null)
                                SectionTag(project.status!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (project.repository != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 20,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openRepository(BuildContext context, String repository) async {
    try {
      final opened = await launchUrl(
        Uri.parse(repository),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this repository.')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open this repository: $error')),
      );
    }
  }
}
