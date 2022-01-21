// ignore_for_file: use_build_context_synchronously

import 'package:dashlist/src/components/components.dart';
import 'package:dashlist/src/modules/shopping/shopping.dart';
import 'package:dashlist/src/modules/shopping/view/create.dart';
import 'package:dashlist/src/services/http/http.dart';
import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

const gray11 = Color(0xFFe8e8ea);

/// Initialize shopping list state.
class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  /// Path: /
  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(shoppingListCollection);

    return asyncList.when(
      loading: () => const Loader(),
      error: (error, _) => const ErrorLayout(),
      data: (_) => const ShoppingListView(),
    );
  }
}

class ShoppingListView extends ConsumerWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shops);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            const _AppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProviderScope(
                    overrides: [
                      scopedShoppingList.overrideWithValue(items[index])
                    ],
                    child: const ShoppingListCard(),
                  ),
                  childCount: items.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AppBar extends ConsumerStatefulWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends ConsumerState<_AppBar> {
  Future<void> _createNewShoppingList() async {
    final name = await CreateListModal.show(context);

    if (name != null && name.isNotEmpty) {
      try {
        await ref.read(shopActions).createNewShoppingList(name);
      } on ApiException catch (exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(exception.reason)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      expandedHeight: 90,
      flexibleSpace: const FlexibleHeader(
        title: Text('Listes de courses'),
        // padding: EdgeInsets.symmetric(horizontal: 32),
      ),
      actions: [
        IconButton(
          onPressed: _createNewShoppingList,
          icon: DashListIcons.addCircle,
        ),
      ],
    );
  }
}

class ShoppingListCard extends ConsumerWidget {
  const ShoppingListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(scopedShoppingList);

    return Slidable(
      key: ValueKey('_Slidable_${shoppingList.id}_'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              ref.read(shopActions).deleteShoppingList(shoppingList);
            },
            backgroundColor: Colors.transparent,
            foregroundColor: DashlistColors.gray6,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: gray11),
        ),
        elevation: 0,
        child: InkWell(
          onTap: () {
            GoRouter.of(context).go('/${shoppingList.id}');
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shoppingList.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      '${shoppingList.items.length} Articles',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
