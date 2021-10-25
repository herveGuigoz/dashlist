import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap.dart';
import 'src/modules/app/app.dart';

void main() {
  bootstrap(() => const ProviderScope(child: Main()));
}
