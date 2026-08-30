import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'mode_select_screen.dart';
import 'settings_screen.dart';
import 'category_browser_screen.dart';
import 'credits_screen.dart';
import 'tutorial_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'GT',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.appTitle,
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        l10n.appTagline,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: l10n.playButton,
                icon: Icons.play_arrow,
                onPressed: () => _push(const ModeSelectScreen()),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SecondaryIcon(
                    icon: Icons.settings,
                    label: l10n.settingsLabel,
                    onTap: () => _push(const SettingsScreen()),
                  ),
                  _SecondaryIcon(
                    icon: Icons.grid_view,
                    label: l10n.categoriesLabel,
                    onTap: () => _push(const CategoryBrowserScreen()),
                  ),
                  _SecondaryIcon(
                    icon: Icons.help_outline,
                    label: l10n.tutorialLabel,
                    onTap: () => _push(const TutorialScreen()),
                  ),
                  _SecondaryIcon(
                    icon: Icons.info_outline,
                    label: l10n.creditsLabel,
                    onTap: () => _push(const CreditsScreen()),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.85)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
