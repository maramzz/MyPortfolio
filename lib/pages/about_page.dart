import 'package:flutter/material.dart';

import 'portfolio_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const facts = [
      ('Education', 'Computer Science'),
      ('University', 'IIT Sfax'),
      ('Location', 'Sfax, Tunisia'),
      ('Languages', 'Arabic · French · English'),
    ];

    return PortfolioPage(
      title: 'About Me',
      label: 'A LITTLE ABOUT ME',
      currentRoute: '/about',
      child: Column(
        children: [
          Text(
            'I’m currently pursuing a Bachelor’s degree in Computer Science at IIT Sfax. My academic journey has helped me build a foundation in programming, databases, web development and software engineering.',
            style: TextStyle(
              fontSize: 16,
              height: 1.75,
            ).copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text(
            'I enjoy understanding how applications work behind the scenes, solving problems and exploring new technologies. I’m particularly interested in backend development and modern software solutions.',
            style: TextStyle(
              fontSize: 16,
              height: 1.75,
            ).copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          PortfolioCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick facts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final fact in facts)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: colors.outlineVariant),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fact.$1,
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            fact.$2,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
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
