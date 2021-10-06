import 'package:dashlist/src/navigation/navigation.dart';
import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DashListIcons.arrowBack,
      color: Colors.black87,
      onPressed: () => Navigator.pop(context),
    );
  }
}
