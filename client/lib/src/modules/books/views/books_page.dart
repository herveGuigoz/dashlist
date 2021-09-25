import 'package:client/src/modules/books/state/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksPage extends ConsumerWidget {
  const BooksPage({Key? key}) : super(key: key);

  static const routeName = '/books';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final response = watch(hubProvider);
    return Scaffold(
      body: response.when(
        data: (value) => Text(value),
        loading: () => const _Loading(),
        error: (error, stackTrace) => _Error(error: error),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({Key? key, required this.error}) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    print(error);
    return Center(
      child: Text(error.toString()),
    );
  }
}
