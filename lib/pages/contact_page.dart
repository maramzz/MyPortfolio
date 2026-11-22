import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'portfolio_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _openUri(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PortfolioPage(
      title: 'Contact',
      label: 'LET’S CONNECT',
      currentRoute: '/contact',
      child: PortfolioCard(
        child: Column(
          children: [
            Text(
              'Have an opportunity in mind?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'I’m open to internship opportunities, collaboration and connecting with other developers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.7),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openUri(
                Uri(scheme: 'mailto', path: 'maramzarrouk0@gmail.com'),
              ),
              icon: const Icon(Icons.mail_outline_rounded),
              label: const Text('maramzarrouk0@gmail.com'),
              style: FilledButton.styleFrom(minimumSize: const Size(220, 52)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  const ClipboardData(text: 'maramzarrouk0@gmail.com'),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Email copied')));
                }
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy email'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(220, 52)),
            ),
            const SizedBox(height: 28),
            _ContactRow(
              label: 'WhatsApp',
              value: '+216 93 304 630',
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () => _openUri(Uri.parse('https://wa.me/21693304630')),
            ),
            _ContactRow(
              label: 'GitHub',
              value: '@maramzz',
              icon: Icons.code_rounded,
              onTap: () => _openUri(Uri.parse('https://github.com/maramzz')),
            ),
            _ContactRow(
              label: 'Resume',
              value: 'Open CV folder',
              icon: Icons.description_outlined,
              onTap: () => _openUri(
                Uri.parse(
                  'https://drive.google.com/drive/folders/16MDDCnFfoWQgiMkLZ-uPxx8EDDKffVj7',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.outlineVariant)),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              value,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
