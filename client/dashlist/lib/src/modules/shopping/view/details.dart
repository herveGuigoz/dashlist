import 'dart:math' as math;

import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/components.dart';
import '../../../navigation/navigation.dart';
import '../../../services/services.dart';
import '../shopping.dart';

class ShoppingListDetailsPage extends ConsumerWidget {
  const ShoppingListDetailsPage({Key? key, required this.id}) : super(key: key);

  /// Path: :id
  static const routeName = ':id';

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ressource = ref.watch(shop(id));

    return ProviderScope(
      overrides: [scopedShoppingList.overrideWithValue(ressource)],
      child: const ShoppingListDetailsView(),
    );
  }
}

class ShoppingListDetailsView extends ConsumerStatefulWidget {
  const ShoppingListDetailsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ShoppingListDetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends ConsumerState<ShoppingListDetailsView> {
  ShoppingList get shoppingList => ref.watch(scopedShoppingList);

  bool get hasCompletedItems {
    return shoppingList.items.any((item) => item.isCompleted);
  }

  Future<void> _createShopItem() async {
    TheRouter.of(context).push('/add/${shoppingList.id}');
  }

  Future<void> onTitleEdited(String input) async {
    if (input.length > 3) {
      try {
        await ref.read(shopActions).editShoppingListName(shoppingList, input);
      } on ApiException catch (exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(exception.reason)),
        );
      }
    }
  }

  Future<void> _deleteCompletedItems() async {
    if (hasCompletedItems) {
      return ref.read(shopActions).deleteCompletedItems(shoppingList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Unfocus(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _createShopItem,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: FlexibleHeader.kExpandedHeight,
                leading: const AppBackButton(),
                flexibleSpace: FlexibleHeader(
                  title: InputText(
                    initialValue: shoppingList.name,
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: onTitleEdited,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: hasCompletedItems
                        ? () async => _deleteCompletedItems()
                        : null,
                    icon: DashListIcons.delete,
                  ),
                ],
              ),
              SliverPadding(
                // todo addaptive paddings
                padding: const EdgeInsets.symmetric(horizontal: 21),
                sliver: SliverShoppingListItems(
                  shoppingListId: shoppingList.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverShoppingListItems extends ConsumerWidget {
  const SliverShoppingListItems({
    Key? key,
    required this.shoppingListId,
  }) : super(key: key);

  final String shoppingListId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shopItems(shoppingListId));
    final builderDelegate = ListItemsBuilderDelegate(items);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final itemIndex = index ~/ 2;
          final Widget widget;
          if (index.isEven) {
            widget = builderDelegate.itemBuilder(context, itemIndex);
          } else {
            widget = builderDelegate.separatorBuilder(context, itemIndex);
          }
          return widget;
        },
        childCount: math.max(0, items.length * 2 - 1),
      ),
    );
  }
}

class ListItemsBuilderDelegate {
  ListItemsBuilderDelegate(this.items) : _categories = items.keys.toList();

  final Map<String, List<Item>> items;

  final List<String> _categories;

  Widget itemBuilder(BuildContext context, int index) {
    final textTheme = Theme.of(context).textTheme.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_categories[index], style: textTheme),
        for (final item in items[_categories[index]]!) CheckboxListItem(item)
      ],
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const Divider();
  }
}

class CheckboxListItem extends ConsumerWidget {
  const CheckboxListItem(this.shopItem, {Key? key}) : super(key: key);

  static const gray5 = Color(0xFF615e69);
  static const gray9 = Color(0xFFbbbabf);

  final Item shopItem;
  bool get isCompleted => shopItem.isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = const TextStyle(fontSize: 15, color: gray5);
    if (isCompleted) {
      textStyle = const TextStyle(
        fontSize: 15,
        decoration: TextDecoration.lineThrough,
        color: gray9,
      );
    }

    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: RichText(
        text: TextSpan(
          style: textStyle,
          children: [
            TextSpan(text: shopItem.quantity),
            const TextSpan(text: ' '),
            TextSpan(text: shopItem.name),
          ],
        ),
      ),
      value: isCompleted,
      onChanged: (completed) async {
        if (completed != null) {
          try {
            final service = ref.read(shopActions);
            await service.editShopItemCompletion(shopItem);
          } on ApiException catch (exception) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(exception.reason)),
            );
          }
        }
      },
    );
  }
}
