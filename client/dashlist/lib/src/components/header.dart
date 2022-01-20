import 'package:flutter/material.dart';

/// With SliverAppBar in a CustomScrollView, the header height will changes when
/// scrolled as FlexibleSpaceBar do.
///
/// ```dart
/// SliverAppBar(
///   pinned: true,
///   expandedHeight: FlexibleHeader.kExpandedHeight,
///   flexibleSpace: const FlexibleHeader(
///     title: Text('Hello world'),
///   ),
/// ),
/// ```
class FlexibleHeader extends StatelessWidget {
  const FlexibleHeader({
    Key? key,
    required this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 21),
  }) : super(key: key);

  static const double kExpandedHeight = 140;

  final Widget title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, index) {
        final s = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
        final delta = s.maxExtent - s.minExtent;
        // 0.0 -> Expanded
        // 1.0 -> Collapsed to toolbar
        final t =
            (1.0 - (s.currentExtent - s.minExtent) / delta).clamp(0.0, 1.0);

        final scaleValue = Tween<double>(begin: 1.5, end: 1).transform(t);

        final paddingLeft = Tween<double>(
          begin: padding.left,
          end: padding.left + 32,
        ).transform(t);

        final paddingBottom = Tween<double>(
          begin: padding.bottom + 8,
          end: padding.bottom,
        ).transform(t);

        final scaleTransform = Matrix4.identity()
          ..scale(scaleValue, scaleValue, 1);

        return DefaultTextStyle(
          style: textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
          child: ClipRect(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: paddingLeft,
                bottom: paddingBottom,
              ),
              child: Transform(
                transform: scaleTransform,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: title,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
