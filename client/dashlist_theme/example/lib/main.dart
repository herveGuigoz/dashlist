import 'package:flutter/material.dart';

import 'package:dashlist_theme/dashlist_theme.dart';

import 'colors.dart';

void main() {
  runApp(
    const AppTheme(
      appThemeData: DashlistThemeData(),
      child: MaterialApp(
        home: GalleryLayout(),
      ),
    ),
  );
}

class GalleryLayout extends StatelessWidget {
  const GalleryLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ColorsGallery(),
      ],
    );
  }
}
