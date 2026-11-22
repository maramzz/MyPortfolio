import 'package:flutter/material.dart';

import '../widgets/portfolio_navigation_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoOffset;
  late final AnimationController _ambientController;
  bool? _reduceMotion;

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
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion == reduceMotion) return;

    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _ambientController
        ..stop()
        ..value = 1;
    } else {
      _ambientController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            onPressed: () => showPortfolioNavigationSheet(context),
            tooltip: 'Open navigation',
            icon: const Icon(Icons.menu_rounded, size: 28),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              key: const ValueKey('home-ambient-background'),
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _ambientController,
                  builder: (context, _) {
                    final progress = Curves.easeInOutSine.transform(
                      _ambientController.value,
                    );
                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          top: -130,
                          right: -120,
                          child: Transform.translate(
                            key: const ValueKey('home-ambient-top-glow'),
                            offset: Offset(-18 * progress, 20 * progress),
                            child: _AmbientGlow(
                              size: 340,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -155,
                          left: -125,
                          child: Transform.translate(
                            key: const ValueKey('home-ambient-bottom-glow'),
                            offset: Offset(16 * progress, -18 * progress),
                            child: _AmbientGlow(
                              size: 320,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              key: const PageStorageKey<String>('home-scroll'),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Center(
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
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
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
                            onPressed: () =>
                                Navigator.pushNamed(context, '/contact'),
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
                            _InfoRow(
                              label: 'Education',
                              value: 'CS · IIT Sfax',
                            ),
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
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withAlpha(24), color.withAlpha(0)],
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
