import 'package:dashlist/src/modules/navigation/pages.dart';
import 'package:dashlist/src/modules/navigation/transitions.dart';
import 'package:dashlist/src/modules/settings/settings.dart';
import 'package:dashlist/src/modules/shopping/shopping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final theRouter = Provider((ref) {
  return GoRouter(
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
        redirect: (state) {
          if (!ref.shoppingListExist(state.params['id']!)) {
            return ShoppingListPage.routeName;
          }
        },
        pageBuilder: (context, state) {
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
    return read(shops).any((list) => list.id == uuid);
  }
}
