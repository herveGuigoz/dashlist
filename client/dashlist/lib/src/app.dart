import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/components.dart';
import 'modules/settings/settings_controller.dart';
import 'modules/shopping/state/providers.dart';
import 'navigation/navigation.dart';

/// Initialize shopping list state to handle deep linking to pages that
/// depends on shopping list.
class Main extends ConsumerWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(shoppingListCollection);

    return asyncList.when(
      data: (_) => const Cocook(),
      loading: () => const Loader(),
      error: (error, _) => Error(error: error),
    );
  }
}

class Cocook extends ConsumerWidget {
  const Cocook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(theRouter);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: DashlistTheme.light,
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(settingsRef),
    );
  }
}
