import 'package:flutter/material.dart';

import '../theme/theme_mode_controller.dart';

Future<void> showPortfolioNavigationSheet(
  BuildContext context, {
  String? activeRoute,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final colors = Theme.of(sheetContext).colorScheme;
      const items = <({String label, IconData icon, String route})>[
        (label: 'About', icon: Icons.person_outline_rounded, route: '/about'),
        (label: 'Skills', icon: Icons.auto_awesome_outlined, route: '/skills'),
        (
          label: 'Experience',
          icon: Icons.work_outline_rounded,
          route: '/experience',
        ),
        (label: 'Work', icon: Icons.grid_view_rounded, route: '/projects'),
        (label: 'Contact', icon: Icons.mail_outline_rounded, route: '/contact'),
      ];

      return SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 560),
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: colors.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      secondary: Icon(
                        Icons.dark_mode_outlined,
                        color: colors.primary,
                      ),
                      title: const Text('Dark mode'),
                      value:
                          Theme.of(sheetContext).brightness == Brightness.dark,
                      onChanged: (enabled) =>
                          ThemeModeScope.of(sheetContext).setDarkMode(enabled),
                    ),
                    const Divider(height: 1),
                    for (final item in items)
                      ListTile(
                        minTileHeight: 52,
                        selected: activeRoute == item.route,
                        selectedTileColor: colors.secondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: Icon(
                          item.icon,
                          color: activeRoute == item.route
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                        title: Text(
                          item.label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: Icon(
                          activeRoute == item.route
                              ? Icons.check_rounded
                              : Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          if (item.route != activeRoute) {
                            Navigator.pushNamed(context, item.route);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
