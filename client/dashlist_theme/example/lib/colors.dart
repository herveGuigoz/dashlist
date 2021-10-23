import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class ColorsGallery extends StatelessWidget {
  const ColorsGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Wrap(
      spacing: theme.edgeInsets.regular.top,
      runSpacing: theme.edgeInsets.regular.top,
      children: [
        theme.colors.accent1,
        theme.colors.accent2,
        theme.colors.background1,
        theme.colors.background2,
        theme.colors.background3,
        theme.colors.foreground1,
        theme.colors.foreground2,
        theme.colors.foregroundOpposite,
        theme.colors.error,
        theme.colors.warning,
      ].map((color) => _ColorTile(color: color)).toList(),
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: SmoothRectangleBorder(
          borderRadius: theme.borderRadius.small,
        ),
      ),
      height: theme.textStyles.title1.fontSize,
      width: theme.textStyles.title1.fontSize,
    );
  }
}
