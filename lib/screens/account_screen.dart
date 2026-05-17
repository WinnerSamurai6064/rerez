import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../app/theme.dart';
import '../widgets/credits_badge.dart';
import '../widgets/footer_text.dart';
import '../widgets/glass_panel.dart';
import '../widgets/orange_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AppState>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: CreditsBadge(
                credits: appState.credits,
                compact: true,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassPanel(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: RerezTheme.orange.withOpacity(0.16),
                            border: Border.all(
                              color: RerezTheme.orange.withOpacity(0.46),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: RerezTheme.orange.withOpacity(0.18),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: RerezTheme.orange,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          user.username,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: RerezTheme.neonWhite,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.isLoggedIn ? 'Logged in' : 'Guest',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: RerezTheme.mutedWhite,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 20),
                        CreditsBadge(credits: appState.credits),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  GlassPanel(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _AccountRow(
                          label: 'Username',
                          value: user.username,
                        ),
                        _AccountRow(
                          label: 'Credits',
                          value: appState.credits.toString(),
                        ),
                        _AccountRow(
                          label: 'Account Status',
                          value: user.isLoggedIn ? 'Logged in' : 'Guest',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  OrangeButton(
                    text: 'Logout',
                    icon: Icons.logout_rounded,
                    onPressed: () => _logout(context),
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

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RerezTheme.softWhite,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RerezTheme.neonWhite,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 13),
          Divider(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
          const SizedBox(height: 13),
        ],
      ],
    );
  }
}
