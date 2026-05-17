import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../app/theme.dart';
import '../models/generation_settings.dart';
import '../widgets/credits_badge.dart';
import '../widgets/glass_panel.dart';
import '../widgets/image_picker_box.dart';
import '../widgets/option_chip_selector.dart';
import '../widgets/orange_button.dart';
import 'auth_screen.dart';
import 'result_screen.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  Future<void> _generate(BuildContext context) async {
    final appState = context.read<AppState>();
    final success = await appState.generate();

    if (!context.mounted) return;

    final message = appState.message;
    if (!success) {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ResultScreen(),
      ),
    );
  }

  void _openAuth(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rerez'),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!appState.isLoggedIn) ...[
                    GlassPanel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      borderRadius: 22,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sign in for 20 credits.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: RerezTheme.mutedWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _openAuth(context),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ImagePickerBox(
                    imageBytes: appState.selectedImageBytes,
                    onSelectImage: appState.pickImage,
                    onClearImage: appState.clearSelectedImage,
                  ),
                  const SizedBox(height: 18),
                  GlassPanel(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OptionChipSelector<ScaleOption>(
                          label: 'Scale',
                          options: ScaleOption.values,
                          selected: settings.scale,
                          labelBuilder: (value) => value.label,
                          onChanged: appState.updateScale,
                        ),
                        const SizedBox(height: 22),
                        OptionChipSelector<ProcessingMethod>(
                          label: 'Method',
                          options: ProcessingMethod.values,
                          selected: settings.method,
                          labelBuilder: (value) => value.label,
                          onChanged: appState.updateMethod,
                        ),
                        const SizedBox(height: 22),
                        OptionChipSelector<ColorProfile>(
                          label: 'Color Profile',
                          options: ColorProfile.values,
                          selected: settings.colorProfile,
                          labelBuilder: (value) => value.label,
                          onChanged: appState.updateColorProfile,
                        ),
                        const SizedBox(height: 22),
                        OptionChipSelector<FilterOption>(
                          label: 'Filters',
                          options: FilterOption.values,
                          selected: settings.filter,
                          labelBuilder: (value) => value.label,
                          onChanged: appState.updateFilter,
                        ),
                        const SizedBox(height: 22),
                        OptionChipSelector<SaveFormat>(
                          label: 'Save As',
                          options: SaveFormat.values,
                          selected: settings.saveFormat,
                          labelBuilder: (value) => value.label,
                          onChanged: appState.updateSaveFormat,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  OrangeButton(
                    text: 'Generate',
                    isLoading: appState.isGenerating,
                    onPressed: appState.isGenerating
                        ? null
                        : () => _generate(context),
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
