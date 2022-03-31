import 'dart:async';

import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({
    Key? key,
    this.initialValue,
    this.decoration = const InputDecoration(border: InputBorder.none),
    this.style,
    required this.onChanged,
  }) : super(key: key);

  const InputText.header({
    Key? key,
    this.initialValue,
    this.decoration = const InputDecoration(border: InputBorder.none),
    required this.onChanged,
  })  : style = const TextStyle(fontWeight: FontWeight.bold),
        super(key: key);

  final String? initialValue;
  final InputDecoration decoration;
  final TextStyle? style;
  final void Function(String) onChanged;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> with DebouncedTextInputMixin {
  @override
  late final textEditingController = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void onChanged(String input) => widget.onChanged(input);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: widget.decoration,
      style: widget.style,
      textAlign: TextAlign.left,
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

/// Listens to the keyboard inputs, but debounce updates to avoid triggering
/// too many HTTP requests.
mixin DebouncedTextInputMixin<T extends StatefulWidget> on State<T> {
  Timer? _timer;

  TextEditingController get textEditingController;

  void onChanged(String input);

  void listener() {
    _timer?.cancel();
    _timer = Timer(
      const Duration(milliseconds: 200),
      () => onChanged(textEditingController.text),
    );
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(listener);
  }

  @override
  void activate() {
    textEditingController.addListener(listener);
    super.activate();
  }

  @override
  void deactivate() {
    _timer?.cancel();
    textEditingController.removeListener(listener);
    super.deactivate();
  }
}
