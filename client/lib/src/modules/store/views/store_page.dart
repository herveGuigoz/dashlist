import 'package:client/src/modules/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoresPage extends ConsumerWidget {
  const StoresPage({Key? key}) : super(key: key);

  static const routeName = '/stores';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(mercureStream);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(),
      body: stream.when(
        data: (event) => Text(event.data),
        loading: () => const _Loading(),
        error: (error, stackTrace) => _Error(error: error),
      ),
    );

    // final stores = watch(mercure);
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: ListView.builder(
    //     itemCount: stores.length,
    //     itemBuilder: (context, index) => Text(stores[index].data),
    //   ),
    // );

    // final response = watch(storesProvider);
    // return Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body: response.when(
    //     data: (stores) => ListView.builder(
    //       restorationId: 'storesListView',
    //       itemCount: stores.length,
    //       itemBuilder: (context, index) => StoreTile(store: stores[index]),
    //     ),
    //     loading: () => const _Loading(),
    //     error: (error, stackTrace) => _Error(error: error),
    //   ),
    // );
  }
}

class StoreTile extends StatelessWidget {
  const StoreTile({Key? key, required this.store}) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(store.name),
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

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
