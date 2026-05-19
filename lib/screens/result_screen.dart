import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../app/theme.dart';
import '../models/generation_settings.dart';
import '../widgets/credits_badge.dart';
import '../widgets/glass_panel.dart';
import '../widgets/orange_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  void _generateAgain(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _save(BuildContext context) {
    final appState = context.read<AppState>();

    if (appState.downloadUrl == null && appState.resultImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No result available to save.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download is ready from the backend result.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;

    final beforeBytes = appState.selectedImageBytes;
    final afterBytes = appState.resultImageBytes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
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
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassPanel(
                    padding: const EdgeInsets.all(14),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 520;

                        final before = _ResultImageCard(
                          title: 'Before',
                          imageBytes: beforeBytes,
                        );

                        final after = _ResultImageCard(
                          title: 'After',
                          imageBytes: afterBytes,
                        );

                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(child: before),
                              const SizedBox(width: 12),
                              Expanded(child: after),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            before,
                            const SizedBox(height: 12),
                            after,
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  GlassPanel(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SettingRow(
                          label: 'Scale',
                          value: appState.resultScale != null
                              ? '${appState.resultScale}x'
                              : settings.scale.label,
                        ),
                        _SettingRow(
                          label: 'Method',
                          value: appState.resultMethod ?? settings.method.label,
                        ),
                        _SettingRow(
                          label: 'Color Profile',
                          value: appState.resultColorProfile ??
                              settings.colorProfile.label,
                        ),
                        _SettingRow(
                          label: 'Filters',
                          value: settings.filter.label,
                        ),
                        _SettingRow(
                          label: 'Save As',
                          value: appState.resultFormat ?? settings.saveFormat.label,
                        ),
                        _SettingRow(
                          label: 'Size',
                          value: _sizeText(
                            appState.resultWidth,
                            appState.resultHeight,
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  OrangeButton(
                    text: 'Save',
                    onPressed: () => _save(context),
                  ),
                  const SizedBox(height: 12),
                  _SecondaryButton(
                    text: 'Generate Again',
                    onPressed: () => _generateAgain(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _sizeText(int? width, int? height) {
    if (width == null || height == null) {
      return 'Ready';
    }

    return '$width×$height';
  }
}

class _ResultImageCard extends StatelessWidget {
  const _ResultImageCard({
    required this.title,
    required this.imageBytes,
  });

  final String title;
  final dynamic imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageBytes != null)
              Image.memory(
                imageBytes,
                fit: BoxFit.cover,
              )
            else
              Container(
                color: RerezTheme.panelBlack,
                child: const Icon(
                  Icons.image_rounded,
                  color: RerezTheme.softWhite,
                  size: 42,
                ),
              ),
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.56),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.14),
                  ),
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RerezTheme.neonWhite,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
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

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

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
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RerezTheme.neonWhite,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
