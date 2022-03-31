import 'package:dashlist/bootstrap.dart';
import 'package:dashlist/modules/app/layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await bootstrap(() => const ProviderScope(child: DashList()));
}
