import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

final productProvider = FutureProvider.family<Product, String>(
  (ref, barcode) async {
    final configurations = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.FRENCH,
      fields: [ProductField.ALL],
    );

    final result = await OpenFoodAPIClient.getProduct(configurations);

    if (result.status == 1) {
      return result.product!;
    } else {
      throw Exception('product for $barcode not found');
    }
  },
);
