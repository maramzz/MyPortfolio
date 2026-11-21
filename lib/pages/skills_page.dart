import 'package:flutter/material.dart';

import 'portfolio_page.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const skills = [
      ('01', 'Programming', 'Java · C · JavaScript · TypeScript · PHP'),
      (
        '02',
        'Backend Development',
        'Spring Boot · REST APIs · JPA / Hibernate',
      ),
      ('03', 'Frontend Development', 'Angular · React · HTML · CSS'),
      ('04', 'Databases', 'PostgreSQL · MySQL · Oracle · SQL'),
      ('05', 'Tools & DevOps', 'Git · GitHub · Docker · Postman'),
      ('06', 'Other Technologies', 'Flutter · Microservices · OOP'),
    ];

    return PortfolioPage(
      title: 'Technical Skills',
      label: 'WHAT I WORK WITH',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technologies and tools I have studied or used in coursework and development projects.',
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.7),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 680 ? 2 : 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final skill in skills)
                    SizedBox(
                      width: columns == 2
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: PortfolioCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                skill.$1,
                                style: TextStyle(
                                  color: colors.onSecondaryContainer,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              skill.$2,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              skill.$3,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
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
}
