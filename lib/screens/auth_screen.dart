import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../app/theme.dart';
import '../services/mock_auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/glass_panel.dart';
import '../widgets/orange_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final MockAuthService _validator = MockAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;
  String? _formMessage;
  bool _isBusy = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continueWithGoogle() async {
    await _runAuthAction(
      () => context.read<AppState>().continueWithGoogle(),
    );
  }

  Future<void> _login() async {
    if (!_validateForm()) return;

    await _runAuthAction(
      () => context.read<AppState>().login(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
    );
  }

  Future<void> _signUp() async {
    if (!_validateForm()) return;

    await _runAuthAction(
      () => context.read<AppState>().signUp(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
    );
  }

  Future<void> _runAuthAction(Future<bool> Function() action) async {
    setState(() {
      _isBusy = true;
      _formMessage = null;
    });

    final success = await action();

    if (!mounted) return;

    setState(() {
      _isBusy = false;
      _formMessage = context.read<AppState>().message;
    });

    if (success) {
      Navigator.of(context).pop();
    }
  }

  bool _validateForm() {
    final usernameError = _validator.validateUsername(_usernameController.text);
    final passwordError = _validator.validatePassword(_passwordController.text);

    setState(() {
      _usernameError = usernameError;
      _passwordError = passwordError;
      _formMessage = null;
    });

    return usernameError == null && passwordError == null;
  }

  void _clearFieldErrors() {
    if (_usernameError == null && _passwordError == null && _formMessage == null) {
      return;
    }

    setState(() {
      _usernameError = null;
      _passwordError = null;
      _formMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rerez'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 22 + bottomInset),
              child: GlassPanel(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Free image upscaling platform',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: RerezTheme.mutedWhite,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 24),
                    OrangeButton(
                      text: 'Continue with Google',
                      icon: Icons.account_circle_rounded,
                      isLoading: _isBusy,
                      onPressed: _isBusy ? null : _continueWithGoogle,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _usernameController,
                      label: 'Username',
                      textInputAction: TextInputAction.next,
                      errorText: _usernameError,
                      onChanged: (_) => _clearFieldErrors(),
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      errorText: _passwordError,
                      onChanged: (_) => _clearFieldErrors(),
                      onSubmitted: (_) => _login(),
                    ),
                    if (_formMessage != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _formMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: RerezTheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    OrangeButton(
                      text: 'Sign Up',
                      isLoading: _isBusy,
                      onPressed: _isBusy ? null : _signUp,
                    ),
                    const SizedBox(height: 12),
                    _SecondaryAuthButton(
                      text: 'Login',
                      onPressed: _isBusy ? null : _login,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryAuthButton extends StatelessWidget {
  const _SecondaryAuthButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

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
