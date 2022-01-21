import 'package:dashlist/bootstrap.dart';
import 'package:dashlist/src/modules/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  bootstrap(() => const ProviderScope(child: Main()));
}
