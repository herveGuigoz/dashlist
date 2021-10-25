import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/settings/settings.dart';
import '../../modules/shopping/shopping.dart';
import 'pages.dart';

final theRouter = Provider((ref) {
  return GoRouter(
    initialLocation: ShoppingListPage.routeName,
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      child: DefaultNotFoundPage(path: state.location),
    ),
    routes: [
      GoRoute(
        path: ShoppingListPage.routeName,
        name: 'ShoppingListPage',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ShoppingListPage(),
        ),
        routes: [
          GoRoute(
            path: ShoppingListDetailsPage.routeName,
            name: 'ShoppingListDetailsPage',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: ShoppingListDetailsPage(id: state.params['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: SettingsPage.routeName,
        name: 'SettingsPage',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: CreateItemPage.routeName,
        name: 'CreateShoppingItemPage',
        pageBuilder: (context, state) {
          final uuid = state.params['id']!;
          if (!ref.shoppingListExist(uuid)) {
            // todo redirection
          }
          return MaterialPage<void>(
            key: state.pageKey,
            child: CreateItemPage(id: state.params['id']!),
          );
        },
      )
    ],
  );
});

extension on ProviderRef {
  bool shoppingListExist(String uuid) {
    return read(shops).any((element) => element.id == uuid);
  }
}
