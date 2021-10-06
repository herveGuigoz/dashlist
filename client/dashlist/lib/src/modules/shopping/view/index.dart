import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../components/components.dart';
import '../../../navigation/navigation.dart';
import '../state/providers.dart';

// TODO own theme
const gray11 = Color(0xFFe8e8ea);

class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shops);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const _AppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: FlexibleHeader.kExpandedHeight,
      flexibleSpace: FlexibleHeader(
        title: Row(
          children: [
            const Text('Listes de courses'),
            IconButton(
              onPressed: () {}, //=> _createNewShoppingList(context),
              icon: DashListIcons.addCircle,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
      ),
    );
  }
}

class ShoppingListCard extends ConsumerWidget {
  const ShoppingListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(scopedShoppingList);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: gray11,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: gray11),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () {
          TheRouter.of(context).go('/${shoppingList.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
