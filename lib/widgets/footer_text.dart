import 'package:flutter/material.dart';

import '../app/theme.dart';

class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Copyright © TREYTEK Inc.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: RerezTheme.softWhite,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
    );
  }
}
