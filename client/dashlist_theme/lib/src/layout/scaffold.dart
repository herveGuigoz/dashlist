import 'dart:math' as math;

import 'package:flutter/material.dart';

// The navigation mechanism to configure the [Scaffold] with.
enum NavigationType {
  // Used to configure a [Scaffold] with a [BottomNavigationBar].
  bottom,

  // Used to configure a [Scaffold] with a modal [Drawer].
  drawer,

  // Used to configure a [Scaffold] with an always open [Drawer].
  permanentDrawer,
}

/// Used to configure destinations in the various navigation mechanism.
class Destination {
  const Destination({
    required this.title,
    required this.icon,
    required this.path,
  });

  final String title;
  final IconData icon;
  final String path;
}

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    Key? key,
    required this.destinations,
    required this.currentPath,
    this.onDestinationSelected,
    this.appBar,
    required this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  /// Defines the appearance of the items that are arrayed within the
  /// navigation. The value must be a list of two or more [Destination].
  final List<Destination> destinations;

  /// Called when one of the [destinations] is selected.
  final ValueChanged<Destination>? onDestinationSelected;

  /// The path for the current selected Destination
  final String currentPath;

  /// See [Scaffold.appBar].
  final PreferredSizeWidget? appBar;

  /// See [Scaffold.body].
  final Widget body;

  /// See [Scaffold.backgroundColor].
  final Color? backgroundColor;

  /// See [Scaffold.resizeToAvoidBottomInset].
  final bool? resizeToAvoidBottomInset;

  int get selectedIndex {
    return destinations.indexWhere(
      (destination) => destination.path == currentPath,
    );
  }

  NavigationType _resolveNavigationType(BuildContext context) {
    if (_isLargeScreen(context)) {
      return NavigationType.permanentDrawer;
    }

    return NavigationType.drawer;
  }

  bool _isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size > const Size(0, 599);
  }

  void _destinationTapped(Destination destination) {
    if (destination.path != currentPath) {
      onDestinationSelected?.call(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationType = _resolveNavigationType(context);

    switch (navigationType) {
      case NavigationType.bottom:
        return _BottomNavigationScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: _destinationTapped,
          appBar: appBar,
          body: body,
        );
      case NavigationType.drawer:
        return _DrawerScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: _destinationTapped,
          appBar: appBar,
          body: body,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
      case NavigationType.permanentDrawer:
        return _PermanentDrawerScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: _destinationTapped,
          appBar: appBar,
          body: body,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
    }
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.destinations,
    this.onDestinationSelected,
  }) : super(key: key);

  final List<Destination> destinations;
  final ValueChanged<Destination>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          for (int i = 0; i < destinations.length; i++)
            ListTile(
              leading: Icon(destinations[i].icon),
              title: Text(destinations[i].title),
              onTap: () {
                onDestinationSelected?.call(destinations[i]);
              },
            )
        ],
      ),
    );
  }
}

class _BottomNavigationScaffold extends StatelessWidget {
  const _BottomNavigationScaffold({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    this.appBar,
    this.body,
    this.onDestinationSelected,
    this.backgroundColor,
  }) : super(key: key);

  final List<Destination> destinations;
  final int selectedIndex;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final ValueChanged<Destination>? onDestinationSelected;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const bottomNavigationOverflow = 5;
    final bottomDestinations = destinations.sublist(
      0,
      math.min(destinations.length, bottomNavigationOverflow),
    );
    final drawerDestinations = destinations.length > bottomNavigationOverflow
        ? destinations.sublist(bottomNavigationOverflow)
        : <Destination>[];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
      drawer: drawerDestinations.isEmpty
          ? null
          : AppDrawer(
              destinations: drawerDestinations,
              onDestinationSelected: onDestinationSelected,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final destination in bottomDestinations)
            BottomNavigationBarItem(
              icon: Icon(destination.icon),
              label: destination.title,
            ),
        ],
        currentIndex: selectedIndex,
        onTap: (i) => onDestinationSelected?.call(destinations[i]),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _DrawerScaffold extends StatelessWidget {
  const _DrawerScaffold({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.appBar,
    this.body,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
  }) : super(key: key);

  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<Destination>? onDestinationSelected;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: AppDrawer(
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
      appBar: appBar,
      body: body,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

class _PermanentDrawerScaffold extends StatelessWidget {
  const _PermanentDrawerScaffold({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    this.appBar,
    this.body,
    this.onDestinationSelected,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
  }) : super(key: key);

  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<Destination>? onDestinationSelected;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Row(
        children: [
          AppDrawer(
            destinations: destinations,
            onDestinationSelected: onDestinationSelected,
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: appBar,
              body: body,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            ),
          ),
        ],
      ),
    );
  }
}
