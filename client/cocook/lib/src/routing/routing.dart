import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_to_regexp/path_to_regexp.dart' as p2re;

import '../modules/settings/settings_view.dart';
import '../modules/shopping/view/shopping_list_page.dart';
import '../modules/store/store.dart';

part 'the_pages.dart';
part 'the_route.dart';
part 'the_router.dart';

/// the signature of the page builder callback for a matched GoRoute
typedef TheRouterPageBuilder = Page<dynamic> Function(
  BuildContext context,
  TheRouterState state,
);

/// the signation of the redirect callback
typedef RouterRedirect = String? Function(TheRouterState state);

typedef RouterBuilderWithMatches = Widget Function(
  BuildContext context,
  Iterable<TheRouteMatch> matches,
);

typedef RouterBuilderWithNavigator = Widget Function(
  BuildContext context,
  Navigator navigator,
);

void _log2(String value) {
  debugPrint('  $value');
}

final theRouter = Provider(
  (ref) => TheRouter(
    initialLocation: ShoppingListPage.routeName,
    routes: [
      TheRoute(
        path: SettingsPage.routeName,
        name: 'settings',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SettingsPage(),
        ),
      ),
      TheRoute(
        path: ShoppingListPage.routeName,
        name: 'stores',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ShoppingListPage(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      child: DefaultNotFoundPage(path: state.location),
    ),
  ),
);
