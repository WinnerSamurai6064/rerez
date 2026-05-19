import 'package:flutter/material.dart';

import '../app/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 86,
    this.showFallback = true,
  });

  final double size;
  final bool showFallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Image.asset(
          'assets/images/rerez_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            if (!showFallback) {
              return const SizedBox.shrink();
            }

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    RerezTheme.orange,
                    RerezTheme.deepOrange,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: RerezTheme.orange.withOpacity(0.28),
                    blurRadius: size * 0.34,
                    offset: Offset(0, size * 0.14),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'R',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: RerezTheme.neonWhite,
                        fontSize: size * 0.45,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -size * 0.04,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
