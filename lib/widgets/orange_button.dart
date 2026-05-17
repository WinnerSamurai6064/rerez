import 'package:flutter/material.dart';

import '../app/theme.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.height = 56,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    final canPress = onPressed != null && !isLoading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: canPress ? 1 : 0.62,
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                RerezTheme.orange.withOpacity(0.95),
                RerezTheme.deepOrange.withOpacity(0.95),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.22),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: RerezTheme.orange.withOpacity(0.32),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canPress ? onPressed : null,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isLoading
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              RerezTheme.neonWhite,
                            ),
                          ),
                        )
                      : Row(
                          key: const ValueKey('content'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                color: RerezTheme.neonWhite,
                                size: 20,
                              ),
                              const SizedBox(width: 9),
                            ],
                            Text(
                              text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: RerezTheme.neonWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.1,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
