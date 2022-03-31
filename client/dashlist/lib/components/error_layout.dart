import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ErrorLayout extends ConsumerWidget {
  const ErrorLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80),
            const Gap(16),
            Text(
              'No Internet Connection',
              style: theme.textTheme.headline5,
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).refresh();
                },
                child: const Text('RETRY'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
