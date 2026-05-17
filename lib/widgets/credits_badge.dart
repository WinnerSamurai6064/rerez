import 'package:flutter/material.dart';

import '../app/theme.dart';

class CreditsBadge extends StatelessWidget {
  const CreditsBadge({
    super.key,
    required this.credits,
    this.compact = false,
  });

  final int credits;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 15,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: RerezTheme.orange.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: RerezTheme.orange.withOpacity(0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: RerezTheme.orange.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: RerezTheme.orange,
            size: 18,
          ),
          SizedBox(width: compact ? 6 : 8),
          Text(
            'Credits',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RerezTheme.mutedWhite,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 6),
          Text(
            credits.toString(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RerezTheme.neonWhite,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}
