import 'package:flutter/material.dart';

import 'portfolio_page.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const responsibilities = [
      'Developed frontend features using Angular and TypeScript.',
      'Worked on backend functionality using Spring Boot and Java.',
      'Used PostgreSQL for application data management.',
      'Implemented project and task management features, including priorities, assignments and comments.',
    ];
    const technologies = [
      'Angular',
      'TypeScript',
      'Java',
      'Spring Boot',
      'PostgreSQL',
    ];

    return PortfolioPage(
      title: 'Experience',
      label: 'MY JOURNEY',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PortfolioCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Software Development Intern',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Telnet',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SectionTag('Summer 2026 · 1 month'),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Worked on a web-based project management application during a one-month summer internship.',
                  style: TextStyle(color: colors.onSurfaceVariant, height: 1.7),
                ),
                const SizedBox(height: 12),
                for (final item in responsibilities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Icon(
                            Icons.circle,
                            size: 6,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final technology in technologies)
                      SectionTag(technology),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Certifications', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          PortfolioCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 44,
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    color: colors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Introduction to AI & Generative AI',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Foundational training on artificial intelligence concepts and generative AI applications.',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Al Nomu Al Ghurair TechUp Explorer · Udacity',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
