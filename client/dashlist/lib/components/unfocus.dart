import 'package:flutter/widgets.dart';

/// {@template unfocus}
/// A widget that unfocus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire child.
///
/// child will commonly be Scaffold widget.
/// {@endtemplate}
class Unfocus extends StatelessWidget {
  /// {@macro unfocus}
  const Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// Widget in the subtree
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
