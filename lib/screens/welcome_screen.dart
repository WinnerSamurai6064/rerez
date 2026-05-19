import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../app/theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/credits_badge.dart';
import '../widgets/footer_text.dart';
import '../widgets/glass_panel.dart';
import '../widgets/orange_button.dart';
import 'generator_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onOpenAuth,
    required this.onOpenGenerator,
  });

  final VoidCallback onOpenAuth;
  final VoidCallback onOpenGenerator;

  void _openGuestGenerator(BuildContext context) {
    onOpenGenerator();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GeneratorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final credits = context.watch<AppState>().credits;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CreditsBadge(credits: credits),
                  ),
                  const SizedBox(height: 46),
                  const Center(
                    child: AppLogo(size: 92),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Rerez',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 58,
                          color: RerezTheme.neonWhite,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Free image upscaling platform',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: RerezTheme.mutedWhite,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 34),
                  GlassPanel(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrangeButton(
                          text: 'Select Image',
                          icon: Icons.add_photo_alternate_rounded,
                          onPressed: () => _openGuestGenerator(context),
                        ),
                        const SizedBox(height: 14),
                        _GlassTextButton(
                          text: 'Continue with Google',
                          icon: Icons.account_circle_rounded,
                          onPressed: onOpenAuth,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _GlassTextButton(
                                text: 'Login',
                                onPressed: onOpenAuth,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GlassTextButton(
                                text: 'Sign Up',
                                onPressed: onOpenAuth,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  const FooterText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTextButton extends StatelessWidget {
  const _GlassTextButton({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: RerezTheme.neonWhite,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: RerezTheme.neonWhite,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
