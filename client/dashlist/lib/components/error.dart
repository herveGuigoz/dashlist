import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({Key? key, required this.error}) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      color: Colors.blueGrey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(error.toString()),
      ),
    );
  }
}
