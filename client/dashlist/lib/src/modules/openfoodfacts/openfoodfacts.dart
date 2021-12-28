import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class Openfoodfacts extends StatelessWidget {
  const Openfoodfacts({Key? key}) : super(key: key);

  Future<String> scanBarcode() {
    return FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // lineColor
      'Cancel', // cancelButtonText
      true, // isShowFlashIcon
      ScanMode.BARCODE,
    );
  }

  void onResult(NavigatorState navigator, String barecode) {
    // cancelled by user
    if (barecode == '-1') return;

    navigator.push(ProductLayout.route(barecode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Barcode scan')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => scanBarcode().then(
              (barecode) => onResult(Navigator.of(context), barecode),
            ),
            child: const Text('Scan'),
          ),
        ),
      ),
    );
  }
}

class ProductLayout extends ConsumerWidget {
  const ProductLayout({
    Key? key,
    required this.barecode,
  }) : super(key: key);

  static Route<void> route(String barecode) {
    return MaterialPageRoute(builder: (_) => ProductLayout(barecode: barecode));
  }

  final String barecode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(barecode));

    return Scaffold(
      body: Center(
        child: product.when(
          data: (product) => Text(product.brands ?? 'null'),
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
