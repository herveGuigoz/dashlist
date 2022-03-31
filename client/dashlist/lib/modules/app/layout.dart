import 'package:dashlist/components/components.dart';
import 'package:dashlist/firebase_options.dart';
import 'package:dashlist/modules/modules.dart';
import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashList extends StatelessWidget {
  const DashList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeferInit(
      create: () async {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        return const Main();
      },
    );
  }
}

class Main extends ConsumerWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(theRouter);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'ShoppingList',
      restorationScopeId: 'app',
      theme: AppThemeData.light,
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(settingsRef),
    );
  }
}
