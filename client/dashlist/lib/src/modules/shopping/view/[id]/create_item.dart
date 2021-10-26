import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../../../../components/components.dart';
import '../../../../services/services.dart';
import '../../shopping.dart';

// todo theme
const gray6 = Color(0xFF77757f);
const gray8 = Color(0xFFa5a3a9);
const _textStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: gray6,
);
const _padding = EdgeInsets.only(top: 32);

class CreateItemPage extends ConsumerStatefulWidget {
  const CreateItemPage({Key? key, required this.id}) : super(key: key);

  /// Path: /add/:id'
  static const routeName = '/add/:id';
  static String path(String id) => pathToFunction(routeName).call({'id': id});

  /// The [ShoppingList] id
  final String id;

  @override
  ConsumerState<CreateItemPage> createState() {
    return _CreateShoppingItemPageState();
  }
}

class _CreateShoppingItemPageState extends ConsumerState<CreateItemPage> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _focuses = <int, FocusNode>{0: FocusNode(), 1: FocusNode()};

  void _nextPage(int page) {
    _unFocusLastPage(page);
    setState(() {});
    _animateToPage(page);
  }

  void _unFocusLastPage(int page) {
    final previousPage = page - 1;
    assert(_focuses.containsKey(previousPage), '_unFocusLastPage error');
    _focuses[previousPage]!.unfocus();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _submitForm(ItemCategory category) async {
    try {
      final service = ref.read(shopActions);
      await service.createShopItem(ShopItemValueObject(
        shoppingListId: widget.id,
        name: _nameController.value.text.trim(),
        quantity: _quantityController.value.text.trim(),
        category: category,
      ));
    } on ApiException catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exception.reason)),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return categories.when(
      data: (items) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          centerTitle: true,
          title: const Text('Nouvel article'),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FormPage(
              delegate: const NameFormDelegate(),
              textController: _nameController,
              focusNode: _focuses[0]!,
              onPressed: () => _nextPage(1),
            ),
            FormPage(
              delegate: const QuantityFormDelegate(),
              textController: _quantityController,
              focusNode: _focuses[1]!,
              onPressed: () => _nextPage(2),
            ),
            _SelectCategoryPage(
              categories: items,
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
      loading: () => const Loader(),
      error: (error, _) => Error(error: error),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    for (final focus in _focuses.values) {
      focus.dispose();
    }
    super.dispose();
  }
}

abstract class FormDelegate {
  const FormDelegate();

  String get title;

  String? get hintText => null;

  TextInputType get keyboardType => TextInputType.text;

  List<TextInputFormatter> get inputFormatters => [];

  int get maxLines => 1;

  bool validate(String input) => true;
}

class NameFormDelegate extends FormDelegate {
  const NameFormDelegate();

  @override
  String get title => 'Quel nom pour cet article?';

  @override
  int get maxLines => 2;

  @override
  bool validate(String input) => input.length > 2;
}

class QuantityFormDelegate extends FormDelegate {
  const QuantityFormDelegate();

  @override
  String get title => 'Voulez-vous définir une quantitée?';

  @override
  List<TextInputFormatter> get inputFormatters {
    return [
      LengthLimitingTextInputFormatter(5),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z\s]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ];
  }
}

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
    required this.delegate,
    required this.textController,
    required this.focusNode,
    required this.onPressed,
  }) : super(key: key);

  final FormDelegate delegate;

  final TextEditingController textController;

  final FocusNode focusNode;

  final VoidCallback onPressed;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  FormDelegate get delegate => widget.delegate;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: gray6,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: [
            Text(delegate.title),
            const Gap(8),
            Expanded(
              child: TextFormField(
                controller: widget.textController,
                focusNode: widget.focusNode,
                autofocus: true,
                keyboardType: delegate.keyboardType,
                inputFormatters: delegate.inputFormatters,
                maxLines: delegate.maxLines,
                style: const TextStyle(color: gray8, fontSize: 28),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: delegate.hintText,
                ),
              ),
            ),
            ButtonBar(
              children: [
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.textController,
                  builder: (context, value, _) => TextButton(
                    onPressed: delegate.validate(widget.textController.text)
                        ? widget.onPressed
                        : null,
                    child: const Text('Suivant'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SelectCategoryPage extends StatelessWidget {
  const _SelectCategoryPage({
    Key? key,
    required this.categories,
    required this.onPressed,
  }) : super(key: key);

  final List<ItemCategory> categories;
  final void Function(ItemCategory category) onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(delegate: _CategoryHeader()),
        SliverFixedExtentList(
          delegate: SliverChildListDelegate.fixed([
            for (final category in categories)
              ListTile(
                dense: true,
                title: Text(category.name),
                subtitle: Text(
                  category.description ?? 'Rayon ${category.name}',
                ),
                onTap: () => onPressed(category),
              )
          ]),
          itemExtent: 56,
        ),
      ],
    );
  }
}

class _CategoryHeader extends SliverPersistentHeaderDelegate {
  static const double _height = 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const Padding(
      padding: _padding,
      child: Text(
        'Dans quelle rayon trouve-t-on\ncet article?',
        textAlign: TextAlign.center,
        style: _textStyle,
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(_CategoryHeader oldDelegate) {
    return false;
  }
}
