// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateListModal extends StatefulWidget {
  const CreateListModal({
    Key? key,
  }) : super(key: key);

  static Future<String?> show(BuildContext context) async {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (_) => const CreateListModal(),
    );
  }

  @override
  State<CreateListModal> createState() => _CreateListModalState();
}

class _CreateListModalState extends State<CreateListModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champs est requis';
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nouvelle liste', style: textTheme.headline6),
            const Gap(16),
            TextFormField(
              controller: _textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Nom'),
              validator: validate,
            ),
            const Gap(32),
            OutlinedButton(
              onPressed: _submit,
              child: const Text('Envoyer'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
