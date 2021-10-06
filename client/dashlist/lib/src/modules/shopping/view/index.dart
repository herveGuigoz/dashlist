// ignore_for_file: use_build_context_synchronously

import 'package:dashlist/src/modules/shopping/state/actions.dart';
import 'package:dashlist/src/modules/shopping/view/create_list.dart';
import 'package:dashlist/src/services/http/http.dart';
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

  /// Path: /
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
      expandedHeight: FlexibleHeader.kExpandedHeight,
      flexibleSpace: FlexibleHeader(
        title: Row(
          children: [
            const Text('Listes de courses'),
            IconButton(
              onPressed: _createNewShoppingList,
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
