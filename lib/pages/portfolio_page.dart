import 'package:flutter/material.dart';

import '../widgets/portfolio_navigation_sheet.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({
    super.key,
    required this.title,
    required this.label,
    required this.currentRoute,
    required this.child,
    this.floatingActionButton,
  });

  final String title;
  final String label;
  final String currentRoute;
  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Open navigation',
            onPressed: () => showPortfolioNavigationSheet(
              context,
              activeRoute: currentRoute,
            ),
            icon: const Icon(Icons.menu_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: PageStorageKey<String>('$title-scroll'),
          padding: EdgeInsets.fromLTRB(
            24,
            32,
            24,
            floatingActionButton == null ? 40 : 112,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                    ).copyWith(color: colors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    width: 56,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 32),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class PortfolioLoadNotice extends StatelessWidget {
  const PortfolioLoadNotice({
    super.key,
    required this.message,
    this.onRetry,
    this.isLoading = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PortfolioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: colors.onSurfaceVariant)),
          if (isLoading) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ] else if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

class PortfolioCard extends StatefulWidget {
  const PortfolioCard({
    super.key,
    required this.child,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isInteractive = widget.onTap != null;
    final borderColor = _isHovered && isInteractive
        ? colors.primary.withAlpha(150)
        : colors.outlineVariant;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: _isHovered && isInteractive
            ? colors.surfaceContainerLow
            : colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHover: isInteractive
              ? (hovered) {
                  if (_isHovered != hovered) {
                    setState(() => _isHovered = hovered);
                  }
                }
              : null,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTag extends StatelessWidget {
  const SectionTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ).copyWith(color: colors.onSecondaryContainer),
      ),
    );
  }
}
