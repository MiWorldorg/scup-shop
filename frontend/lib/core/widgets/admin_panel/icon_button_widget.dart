import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(onTap == null ? 0.08 : 0.2),
            ),
          ),
          child: Icon(
            icon,
            color: onTap == null ? color.withOpacity(0.5) : color,
          ),
        ),
      ),
    );
  }
}
