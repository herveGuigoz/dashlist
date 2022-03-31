import 'package:dashlist/modules/modules.dart';
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
        builder: (context, state) => const ShoppingListPage(),
        routes: [
          GoRoute(
            path: ShoppingListDetailsPage.routeName,
            name: 'ShoppingListDetailsPage',
            builder: (context, state) {
              return ShoppingListDetailsPage(id: state.params['id']!);
            },
          ),
        ],
      ),
      GoRoute(
        path: SettingsPage.routeName,
        name: 'SettingsPage',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: CreateItemPage.routeName,
        name: 'CreateShoppingItemPage',
        redirect: (state) {
          if (!ref.shoppingListExist(state.params['id']!)) {
            return ShoppingListPage.routeName;
          }
          return null;
        },
        builder: (context, state) {
          return CreateItemPage(shoppingList: state.extra! as ShoppingList);
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
