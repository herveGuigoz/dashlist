part of 'navigation.dart';

class TheRouter extends ChangeNotifier {
  TheRouter({
    required List<TheRoute> routes,
    required TheRouterPageBuilder errorPageBuilder,
    RouterRedirect? redirect,
    Listenable? refreshListenable,
    String initialLocation = '/',
    bool debugLogDiagnostics = false,
  }) {
    routerDelegate = TheRouterDelegate(
      routes: routes,
      errorPageBuilder: errorPageBuilder,
      topRedirect: redirect ?? (_) => null,
      refreshListenable: refreshListenable,
      initUri: Uri.parse(initialLocation),
      onLocationChanged: notifyListeners,
      debugLogDiagnostics: debugLogDiagnostics,
      // wrap the returned Navigator to enable TheRouter.of(context).go()
      builderWithNav: (context, navigator) {
        return InheritedRouter(router: this, child: navigator);
      },
    );
  }

  /// Find the current TheRouter in the widget tree
  static TheRouter of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedRouter>()!
        .router;
  }

  /// RouteInformationParser implementation.
  final routeInformationParser = TheRouteInformationParser();

  /// RouterDelegate implementation.
  late final TheRouterDelegate routerDelegate;

  /// Get the current location
  String get location => routerDelegate.currentConfiguration.toString();

  /// Navigate to a URI
  void go(String location) => routerDelegate.go(location);

  /// Navigate to a named route eg: name='book', params={'id': '2'}
  void goNamed(String name, [Map<String, String> params = const {}]) {
    routerDelegate.goNamed(name, params);
  }

  /// Push a URI location onto the page stack.
  void push(String location) => routerDelegate.push(location);

  /// Push a named route onto the page stack.
  void pushNamed(String name, [Map<String, String> params = const {}]) {
    routerDelegate.pushNamed(name, params);
  }

  /// Refresh the route.
  void refresh() => routerDelegate.refresh();
}

/// TheRouter implementation of RouterDelegate
class TheRouterDelegate extends RouterDelegate<Uri>
    with PopNavigatorRouterDelegateMixin<Uri>, ChangeNotifier {
  TheRouterDelegate({
    required this.builderWithNav,
    required this.routes,
    required this.errorPageBuilder,
    required this.topRedirect,
    required this.refreshListenable,
    required Uri initUri,
    required VoidCallback onLocationChanged,
    required this.debugLogDiagnostics,
  }) {
    // Check route route paths are valid: each path must start with /
    for (final route in routes) {
      if (!route.path.startsWith('/')) {
        throw Exception('route path must start with "/": ${route.path}');
      }
    }

    // Cache the set of named routes.
    _cacheNamedRoutes(routes, '', _namedMatches);

    // DebugPrint known routes
    _outputKnownRoutes();

    // build the list of route matches
    _go(initUri.toString());

    // when the listener changes, refresh the route
    refreshListenable?.addListener(refresh);

    // when the location changes, call the callback
    // NOTE: waiting until after the initial call to _go() to hook this up
    // to avoid the case where all of the GoRouter initialization isn't done
    // ignore: prefer_initializing_formals
    this.onLocationChanged = onLocationChanged;
  }

  /// Navigator builder
  final RouterBuilderWithNavigator builderWithNav;

  /// List of defined [TheRoute]
  final List<TheRoute> routes;

  /// Build the page to display on unknow route.
  final TheRouterPageBuilder errorPageBuilder;

  /// Guard middleware.
  final RouterRedirect topRedirect;

  /// Force refresh the router every times this listenable notify changes.
  final Listenable? refreshListenable;

  /// Aditional callback to trigger when location is updated.
  VoidCallback? onLocationChanged;

  /// Allow debug prints.
  final bool debugLogDiagnostics;

  /// The main navigator key.
  final _key = GlobalKey<NavigatorState>();

  final List<TheRouteMatch> _matches = [];
  final _namedMatches = <String, TheRouteMatch>{};
  final _pushCounts = <String, int>{};

  /// for internal use; visible for testing only
  @visibleForTesting
  List<TheRouteMatch> get matches => _matches;

  void _cacheNamedRoutes(
    List<TheRoute> routes,
    String parentFullpath,
    Map<String, TheRouteMatch> namedFullpaths,
  ) {
    for (final route in routes) {
      if (route.name != null) {
        final name = route.name!.toLowerCase();
        final fullpath = _fullLocFor(parentFullpath, route.path);
        if (namedFullpaths.containsKey(name)) {
          throw Exception(
            'duplication fullpaths for name "$name": ${namedFullpaths[name]!.fullpath}, $fullpath',
          );
        }

        // we only have a partial match until we have a location;
        // we're really only caching the route and fullpath at this point
        final match = TheRouteMatch(
          route: route,
          subloc: '/TBD',
          fullpath: fullpath,
          params: {},
          queryParams: {},
        );

        namedFullpaths[name] = match;
        if (route.routes.isNotEmpty) {
          _cacheNamedRoutes(route.routes, fullpath, namedFullpaths);
        }
      }
    }
  }

  /// navigate to the given location
  void go(String location) {
    _log('going to $location');
    _go(location);
    _safeNotifyListeners();
  }

  /// navigate to the named route
  void goNamed(String name, Map<String, String> params) {
    go(_lookupNamedRoute(name, params));
  }

  /// push the given location onto the page stack
  void push(String location) {
    _log('pushing $location');
    _push(location);
    _safeNotifyListeners();
  }

  /// push the named route onto the page stack
  void pushNamed(String name, Map<String, String> params) {
    push(_lookupNamedRoute(name, params));
  }

  /// refresh the current location, including re-evaluating redirections
  void refresh() {
    _log('refreshing $location');
    _go(location);
    _safeNotifyListeners();
  }

  /// get the current location, e.g. /family/f2/person/p1
  String get location {
    return _addQueryParams(_matches.last.subloc, _matches.last.queryParams);
  }

  /// dispose resources held by the router delegate
  @override
  void dispose() {
    refreshListenable?.removeListener(refresh);
    super.dispose();
  }

  /// for use by the Router architecture as part of the RouterDelegate
  @override
  GlobalKey<NavigatorState> get navigatorKey => _key;

  /// for use by the Router architecture as part of the RouterDelegate
  @override
  Uri get currentConfiguration {
    _log2('GoRouterDelegate.currentConfiguration: $location');
    return Uri.parse(location);
  }

  /// for use by the Router architecture as part of the RouterDelegate
  @override
  Widget build(BuildContext context) {
    _log2('GoRouterDelegate.build: matches=');
    for (final match in matches) {
      _log2('  $match');
    }
    return _builder(context, _matches);
  }

  /// for use by the Router architecture as part of the RouterDelegate
  @override
  Future<void> setInitialRoutePath(Uri configuration) async {
    _log2(
      'GoRouterDelegate.setInitialRoutePath: configuration= $configuration',
    );

    // if the initial location is /, then use the dev initial location;
    // otherwise, we're cruising to a deep link, so ignore dev initial location
    final config = configuration.toString();
    if (config == '/') {
      _go(location);
    } else {
      _log('deep linking to $config');
      _go(config);
    }
  }

  /// for use by the Router architecture as part of the RouterDelegate
  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _log2('GoRouterDelegate.setNewRoutePath: configuration= $configuration');
    final config = configuration.toString();
    _log('going to $config');
    _go(config);
  }

  String _lookupNamedRoute(String name, Map<String, String> params) {
    _log(
      'looking up named route "$name"${params.isEmpty ? '' : ' with $params'}',
    );

    // find route and build up the full path along the way
    final match = getNameRouteMatch(name, params);
    if (match == null) throw Exception('unknown route name: $name');

    return _addQueryParams(match.subloc, match.queryParams);
  }

  void _go(String location) {
    final matches = _getLocRouteMatchesWithRedirects(location);
    assert(matches.isNotEmpty);

    // replace the stack of matches w/ the new ones
    _matches.clear();
    _matches.addAll(matches);
    _locationChanged();
  }

  void _push(String location) {
    final matches = _getLocRouteMatchesWithRedirects(location);
    assert(matches.isNotEmpty);
    final top = matches.last;

    // remap the pageKey so allow any number of the same page on the stack
    final fullpath = top.fullpath;
    final count = (_pushCounts[fullpath] ?? 0) + 1;
    _pushCounts[fullpath] = count;
    final pageKey = ValueKey('$fullpath-p$count');
    final match = TheRouteMatch(
      route: top.route,
      subloc: top.subloc,
      fullpath: top.fullpath,
      params: top.params,
      queryParams: top.queryParams,
      pageKey: pageKey,
    );

    // add a new match onto the stack of matches
    assert(matches.isNotEmpty);
    _matches.add(match);
    _locationChanged();
  }

  List<TheRouteMatch> _getLocRouteMatchesWithRedirects(String location) {
    // start redirecting from the initial location
    List<TheRouteMatch> matches;

    try {
      // watch redirects for loops
      final redirects = [_canonicalUri(location)];
      bool redirected(String? redir) {
        if (redir == null) return false;

        if (redirects.contains(redir)) {
          redirects.add(redir);
          final msg = 'Redirect loop detected: ${redirects.join(' => ')}';
          throw Exception(msg);
        }

        redirects.add(redir);
        _log('redirecting to $redir');
        return true;
      }

      // keep looping till we're done redirecting
      for (;;) {
        final loc = redirects.last;

        // check for top-level redirect
        if (redirected(
          topRedirect(
            TheRouterState(
              location: loc,
              // trim the query params off the subloc to match route.redirect
              subloc: Uri.parse(loc).path,
            ),
          ),
        )) continue;

        // get stack of route matches
        matches = getLocRouteMatches(loc);

        // check top route for redirect
        final top = matches.last;
        if (redirected(
          top.route.redirect(
            TheRouterState(
              location: loc,
              subloc: top.subloc,
              path: top.route.path,
              fullpath: top.fullpath,
              params: top.params,
            ),
          ),
        )) continue;

        // let Router know to update the address bar
        // the initial route is not a redirect
        if (redirects.length > 1) {
          _safeNotifyListeners();
        }

        // no more redirects!
        break;
      }
    } on Exception catch (ex) {
      // create a match that routes to the error page
      final uri = Uri.parse(location);
      matches = [
        TheRouteMatch(
          subloc: uri.path,
          fullpath: uri.path,
          params: {},
          queryParams: uri.queryParameters,
          route: TheRoute(
            path: location,
            pageBuilder: (context, state) => errorPageBuilder(
              context,
              TheRouterState(
                location: state.location,
                subloc: state.subloc,
                error: ex,
                fullpath: '',
              ),
            ),
          ),
        ),
      ];
    }

    assert(matches.isNotEmpty);
    return matches;
  }

  /// for internal use; visible for testing only
  @visibleForTesting
  List<TheRouteMatch> getLocRouteMatches(String location) {
    final uri = Uri.parse(location);
    final matchStacks = _getLocRouteMatchStacks(
      loc: uri.path,
      restLoc: uri.path,
      routes: routes,
      parentFullpath: '',
      parentSubloc: '',
      queryParams: uri.queryParameters,
    ).toList();

    if (matchStacks.isEmpty) {
      throw Exception('no routes for location: $location');
    }

    if (matchStacks.length > 1) {
      final sb = StringBuffer();
      sb.writeln('too many routes for location: $location');

      for (final stack in matchStacks) {
        sb.writeln('\t${stack.map((m) => m.route.path).join(' => ')}');
      }

      throw Exception(sb.toString());
    }

    if (kDebugMode) {
      assert(matchStacks.length == 1);
      final match = matchStacks.first.last;
      final loc1 = _addQueryParams(
        match.subloc.toLowerCase(),
        match.queryParams,
      );
      final loc2 = _canonicalUri(location.toLowerCase());
      assert(loc1 == loc2);
    }

    return matchStacks.first;
  }

  /// Turns a list [TheRoute] into a list of [TheRouteMatch] for the location
  /// e.g. routes: ['/', 'book/:id', '/login']
  ///
  /// loc: /
  /// stacks: [ matches: [ match(route.path=/, loc=/) ] ]
  ///
  /// loc: /login
  /// stacks: [ matches: [ match(route.path=/login, loc=login) ] ]
  ///
  /// loc: /book/2
  /// stacks: [
  ///   matches: [
  ///     match(route.path=/, loc=/),
  ///     match(route.path=book/:id, loc=book/2, params=[id=2])
  ///   ]
  /// ]
  ///
  /// loc: /author/2/book/1
  /// stacks: [
  ///   matches: [
  ///     match(route.path=/, loc=/),
  ///     match(route.path=author/:authorId, loc=author/2, params=[authorId=2])
  ///     match(route.path=book/:bookId, loc=book/1, params=[authorId=2, bookId=1])
  ///   ]
  /// ]
  ///
  /// A stack count of 0 means there's no match.
  /// A stack count of >1 means there's a malformed set of routes.
  ///
  /// NOTE: Uses recursion, which is why _getLocRouteMatchStacks calls this
  /// function and does the actual error checking, using the returned stacks to
  /// provide better errors
  static Iterable<List<TheRouteMatch>> _getLocRouteMatchStacks({
    required String loc,
    required String restLoc,
    required String parentSubloc,
    required List<TheRoute> routes,
    required String parentFullpath,
    required Map<String, String> queryParams,
  }) sync* {
    // find the set of matches at this level of the tree
    for (final route in routes) {
      final fullpath = _fullLocFor(parentFullpath, route.path);
      final match = TheRouteMatch._match(
        route: route,
        restLoc: restLoc,
        parentSubloc: parentSubloc,
        path: route.path,
        fullpath: fullpath,
        queryParams: queryParams,
      );
      if (match == null) continue;

      // if we have a complete match, then return the matched route
      if (match.subloc == loc) {
        yield [match];
        continue;
      }

      // if we have a partial match but no sub-routes, bail
      if (route.routes.isEmpty) continue;

      // otherwise recurse
      final childRestLoc = loc.substring(
        match.subloc.length + (match.subloc == '/' ? 0 : 1),
      );
      assert(loc.startsWith(match.subloc));
      assert(restLoc.isNotEmpty);

      // if there's no sub-route matches, then we don't have a match for this
      // location
      final subRouteMatchStacks = _getLocRouteMatchStacks(
        loc: loc,
        restLoc: childRestLoc,
        parentSubloc: match.subloc,
        routes: route.routes,
        parentFullpath: fullpath,
        queryParams: queryParams,
      ).toList();
      if (subRouteMatchStacks.isEmpty) continue;

      // add the match to each of the sub-route match stacks and return them
      for (final stack in subRouteMatchStacks) {
        yield [match, ...stack];
      }
    }
  }

  /// for internal use; visible for testing only
  @visibleForTesting
  TheRouteMatch? getNameRouteMatch(
    String name, [
    Map<String, String> params = const {},
  ]) {
    final partialMatch = _namedMatches[name];
    if (partialMatch == null) return null;
    return TheRouteMatch._matchNamed(
      name: name,
      fullpath: partialMatch.fullpath,
      params: params,
      route: partialMatch.route,
    );
  }

  // parentFullLoc: '',          path: ''         => '/'
  // parentFullLoc: '/',         path: 'book/:id' => '/book/:id'
  // parentFullLoc: '/',         path: 'book/2'   => '/book/2'
  // parentFullLoc: '/author/2', path: 'book/1'   => '/author/2/book/1'
  static String _fullLocFor(String parentFullLoc, String path) {
    // at the root, just return the path
    if (parentFullLoc.isEmpty) {
      assert(path.startsWith('/'));
      assert(path == '/' || !path.endsWith('/'));
      return path;
    }

    // not at the root, so append the parent path
    assert(path.isNotEmpty);
    assert(!path.startsWith('/'));
    assert(!path.endsWith('/'));
    return '${parentFullLoc == '/' ? '' : parentFullLoc}/$path';
  }

  Widget _builder(BuildContext context, Iterable<TheRouteMatch> matches) {
    List<Page<dynamic>> pages;

    try {
      // build the stack of pages
      pages = getPages(context, matches.toList()).toList();
    } on Exception catch (ex) {
      // if there's an error, show an error page
      pages = [
        errorPageBuilder(
          context,
          TheRouterState(location: location, subloc: location, error: ex),
        ),
      ];
    }

    // wrap the returned Navigator to enable GoRouter.of(context).go()
    return builderWithNav(
      context,
      Navigator(
        pages: pages,
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) return false;

          _log2('GoRouterDelegate.onPopPage: matches.last= ${_matches.last}');
          _matches.remove(_matches.last);
          _locationChanged();

          return true;
        },
      ),
    );
  }

  /// Get the stack of sub-routes that matches the location and turn it into a
  /// stack of pages.
  @visibleForTesting
  Iterable<Page<dynamic>> getPages(
    BuildContext context,
    List<TheRouteMatch> matches,
  ) sync* {
    assert(matches.isNotEmpty);
    var params = matches.first.queryParams; // start w/ the query parameters
    if (kDebugMode) {
      for (final match in matches) {
        assert(match.queryParams == matches.first.queryParams);
      }
    }

    for (final match in matches) {
      // merge new params, overriding old ones, i.e. path params override
      // query parameters, sub-location params override top level params, etc.
      // this also keeps params from previously matched paths, e.g.
      // /family/:fid/person/:pid provides fid and pid to person/:pid
      params = {...params, ...match.params};

      // get a page from the builder and associate it with a sub-location
      yield match.route.pageBuilder(
        context,
        TheRouterState(
          location: location,
          subloc: match.subloc,
          path: match.route.path,
          fullpath: match.fullpath,
          params: params,
          pageKey: match.pageKey, // push() remaps the page key for uniqueness
        ),
      );
    }
  }

  /// Build uri with query parameters
  static String _addQueryParams(String loc, Map<String, String> queryParams) {
    final uri = Uri.parse(loc);
    assert(uri.queryParameters.isEmpty);
    return _canonicalUri(
      Uri(path: uri.path, queryParameters: queryParams).toString(),
    );
  }

  // e.g. %20 => +
  static String _canonicalUri(String loc) {
    final uri = Uri.parse(loc);
    final canon = Uri.decodeFull(
      Uri(path: uri.path, queryParameters: uri.queryParameters).toString(),
    );
    return canon.endsWith('?') ? canon.substring(0, canon.length - 1) : canon;
  }

  // HACK: this is a hack to fix the following error:
  // The following assertion was thrown while dispatching notifications for
  // TheRouterDelegate: setState() or markNeedsBuild() called during build.
  void _safeNotifyListeners() {
    final instance = WidgetsBinding.instance;
    if (instance != null) {
      instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  void _locationChanged() {
    _log('location changed to $location');
    onLocationChanged?.call();
  }

  void _log(Object o) {
    if (debugLogDiagnostics) debugPrint('TheRouter: $o');
  }

  void _outputKnownRoutes() {
    if (!debugLogDiagnostics) return;
    _log('known full paths for routes:');
    _outputFullPathsFor(routes, '', 0);

    if (_namedMatches.isNotEmpty) {
      _log('known full paths for route names:');
      for (final e in _namedMatches.entries) {
        _log('  ${e.key} => ${e.value.fullpath}');
      }
    }
  }

  void _outputFullPathsFor(
    List<TheRoute> routes,
    String parentFullpath,
    int depth,
  ) {
    assert(debugLogDiagnostics);

    for (final route in routes) {
      final fullpath = _fullLocFor(parentFullpath, route.path);
      _log('  => ${''.padLeft(depth * 2)}$fullpath');
      _outputFullPathsFor(route.routes, fullpath, depth + 1);
    }
  }
}

/// TheRouter implementation of InheritedWidget for purposes of finding the
/// current TheRouter in the widget tree. This is useful when routing from
/// anywhere in your app.
class InheritedRouter extends InheritedWidget {
  const InheritedRouter({
    required Widget child,
    required this.router,
    Key? key,
  }) : super(child: child, key: key);

  final TheRouter router;

  /// for use by the Router architecture as part of the InheritedWidget
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

/// Dart extension to add navigation function to a BuildContext object, e.g.
/// context.go('/');
extension TheRouterExtensions on BuildContext {
  /// navigate to a location
  void go(String location) => TheRouter.of(this).go(location);

  /// navigate to a named route
  void goNamed(String name, [Map<String, String> params = const {}]) =>
      TheRouter.of(this).goNamed(name, params);

  /// push a location onto the page stack
  void push(String location) => TheRouter.of(this).push(location);

  /// navigate to a named route onto the page stack
  void pushNamed(String name, [Map<String, String> params = const {}]) =>
      TheRouter.of(this).pushNamed(name, params);
}
