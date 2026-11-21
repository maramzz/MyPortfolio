import 'package:flutter/material.dart';

import '../theme/theme_mode_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoOffset;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      value: 1,
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoOffset = Tween<Offset>(begin: const Offset(-0.35, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void openMenu() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          final sheetColors = Theme.of(sheetContext).colorScheme;
          final items = <({String label, IconData icon, String route})>[
            (
              label: 'About',
              icon: Icons.person_outline_rounded,
              route: '/about',
            ),
            (
              label: 'Skills',
              icon: Icons.auto_awesome_outlined,
              route: '/skills',
            ),
            (
              label: 'Experience',
              icon: Icons.work_outline_rounded,
              route: '/experience',
            ),
            (label: 'Work', icon: Icons.grid_view_rounded, route: '/projects'),
            (
              label: 'Contact',
              icon: Icons.mail_outline_rounded,
              route: '/contact',
            ),
          ];

          return SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: sheetColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: sheetColors.outlineVariant),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: sheetColors.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        Icons.dark_mode_outlined,
                        color: sheetColors.primary,
                      ),
                      title: const Text('Dark mode'),
                      value:
                          Theme.of(sheetContext).brightness == Brightness.dark,
                      onChanged: (enabled) =>
                          ThemeModeScope.of(sheetContext).setDarkMode(enabled),
                    ),
                    for (final item in items)
                      ListTile(
                        minTileHeight: 56,
                        leading: Icon(item.icon, color: sheetColors.primary),
                        title: Text(
                          item.label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: sheetColors.onSurfaceVariant,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.pushNamed(context, item.route);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SlideTransition(
              position: _logoOffset,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Hero(
                  tag: 'portfolio-logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 32,
                    width: 32,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'MyPortfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ).copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: openMenu,
            tooltip: 'Open navigation',
            icon: const Icon(Icons.menu_rounded, size: 28),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey<String>('home-scroll'),
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Text(
                    'Computer Science Student · Sfax, Tunisia',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ).copyWith(color: colorScheme.onSecondaryContainer),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Hello, I’m',
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontSize: 46, height: 1.05),
                ),
                Text(
                  'Maram.',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 46,
                    height: 1.05,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'I’m a Computer Science student interested in software development, backend engineering and building useful digital solutions.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    height: 1.7,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/experience'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(190, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Explore my experience'),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(150, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Get in touch'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: const Column(
                    children: [
                      _InfoRow(label: 'Education', value: 'CS · IIT Sfax'),
                      _InfoRow(
                        label: 'Availability',
                        value: 'Open to internships',
                      ),
                      _InfoRow(label: 'Languages', value: 'AR · FR · EN'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
