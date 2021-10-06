part of 'navigation.dart';

/// for route state during routing
class TheRouterState {
  TheRouterState({
    required this.location,
    required this.subloc,
    this.path,
    this.fullpath,
    this.params = const <String, String>{},
    this.error,
    ValueKey<String>? pageKey,
  })  : pageKey = pageKey ?? setPageKey(subloc, fullpath, error),
        assert((path ?? '').isEmpty == (fullpath ?? '').isEmpty);

  static ValueKey<String> setPageKey(
    String subloc, [
    String? fullpath,
    Exception? error,
  ]) {
    if (error != null) return const ValueKey('error');
    if (fullpath != null && fullpath.isNotEmpty) return ValueKey(fullpath);
    return ValueKey(subloc);
  }

  // The full location of the route, e.g. /family/1/person/2
  final String location;

  // The location of this sub-route, e.g. /family/1
  final String subloc;

  // The path to this sub-route, e.g. family/:id
  final String? path;

  // The full path to this sub-route, e.g. /family/:id
  final String? fullpath;

  // The parameters for this sub-route, e.g. {'id': '1'}
  final Map<String, String> params;

  // The error associated with this sub-route
  final Exception? error;

  /// the unique key for this sub-route, e.g. ValueKey('/family/:fid')
  final ValueKey<String> pageKey;
}

/// Declarative mapping between a route path and a page builder
class TheRoute {
  TheRoute({
    required this.path,
    this.name,
    this.pageBuilder = _builder,
    this.routes = const [],
    this.redirect = _redirect,
  }) {
    if (path.isEmpty) {
      throw Exception('TheRoute.path cannot be empty');
    }

    if (name != null && name!.isEmpty) {
      throw Exception('TheRoute.name cannot be empty');
    }

    // cache the path regexp and parameters
    _pathRE = p2re.pathToRegExp(
      path,
      prefix: true,
      caseSensitive: false,
      parameters: _pathParams,
    );

    // check path params
    final paramNames = <String>[];
    p2re.parse(path, parameters: paramNames);
    final groupedParams = paramNames.groupListsBy((param) => param);
    final duplicateParams = Map<String, List<String>>.fromEntries(
      groupedParams.entries.where((e) => e.value.length > 1),
    );
    if (duplicateParams.isNotEmpty) {
      throw Exception(
        'duplicate path params: ${duplicateParams.keys.join(', ')}',
      );
    }

    // check sub-routes
    for (final route in routes) {
      // check paths
      if (route.path != '/' &&
          (route.path.startsWith('/') || route.path.endsWith('/'))) {
        throw Exception(
          'sub-route path may not start or end with /: ${route.path}',
        );
      }
    }
  }

  final _pathParams = <String>[];
  late final RegExp _pathRE;

  final String? name;
  final String path;
  final TheRouterPageBuilder pageBuilder;
  final List<TheRoute> routes;
  final RouterRedirect redirect;

  /// match this route against a location
  Match? matchPatternAsPrefix(String loc) => _pathRE.matchAsPrefix(loc);

  /// extract the path parameters from a match
  Map<String, String> extractPathParams(Match match) =>
      p2re.extract(_pathParams, match);

  static String? _redirect(TheRouterState state) => null;

  static Page<dynamic> _builder(BuildContext context, TheRouterState state) =>
      throw Exception('GoRoute builder parameter not set');
}

/// TheRouter implementation of the RouteInformationParser base class
class TheRouteInformationParser extends RouteInformationParser<Uri> {
  /// for use by the Router architecture as part of the RouteInformationParser
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    _log2(
        'GoRouteInformationParser.parseRouteInformation: routeInformation.location= ${routeInformation.location}');
    return Uri.parse(routeInformation.location!);
  }

  /// for use by the Router architecture as part of the RouteInformationParser
  @override
  RouteInformation restoreRouteInformation(Uri configuration) {
    _log2(
        'GoRouteInformationParser.parseRouteInformation: configuration= $configuration');
    return RouteInformation(location: configuration.toString());
  }
}

/// Each TheRouteMatch instance represents an instance of a TheRoute for a
/// specific portion of a location.
class TheRouteMatch {
  TheRouteMatch({
    required this.route,
    required this.subloc,
    required this.fullpath,
    required this.params,
    required this.queryParams,
    this.pageKey,
  })  : assert(subloc.startsWith('/')),
        assert(Uri.parse(subloc).queryParameters.isEmpty),
        assert(fullpath.startsWith('/')),
        assert(Uri.parse(fullpath).queryParameters.isEmpty);

  final TheRoute route;
  final String subloc; // e.g. /family/f2
  final String fullpath; // e.g. /family/:fid
  final Map<String, String> params;
  final Map<String, String> queryParams;
  final ValueKey<String>? pageKey;

  static TheRouteMatch? _match({
    required TheRoute route,
    required String restLoc, // e.g. person/p1
    required String parentSubloc, // e.g. /family/f2
    required String path, // e.g. person/:pid
    required String fullpath, // e.g. /family/:fid/person/:pid
    required Map<String, String> queryParams,
  }) {
    assert(!path.contains('//'));

    final match = route.matchPatternAsPrefix(restLoc);
    if (match == null) return null;

    final params = route.extractPathParams(match);
    final pathLoc = _locationFor(path, params);
    final subloc = TheRouterDelegate._fullLocFor(parentSubloc, pathLoc);
    return TheRouteMatch(
      route: route,
      subloc: subloc,
      fullpath: fullpath,
      params: params,
      queryParams: queryParams,
    );
  }

  // ignore: prefer_constructors_over_static_methods
  static TheRouteMatch _matchNamed({
    required TheRoute route,
    required String name, // e.g. person
    required String fullpath, // e.g. /family/:fid/person/:pid
    required Map<String, String> params, // e.g. {'fid': 'f2', 'pid': 'p1'}
  }) {
    assert(route.name != null);
    assert(route.name!.toLowerCase() == name.toLowerCase());

    // check that we have all the params we need
    final paramNames = <String>[];
    p2re.parse(fullpath, parameters: paramNames);
    for (final paramName in paramNames) {
      if (!params.containsKey(paramName)) {
        throw Exception('missing param "$paramName" for $fullpath');
      }
    }

    // split params into posParams and queryParams
    final posParams = <String, String>{};
    final queryParams = <String, String>{};
    for (final key in params.keys) {
      if (paramNames.contains(key)) {
        posParams[key] = params[key]!;
      } else {
        queryParams[key] = params[key]!;
      }
    }

    final subloc = _locationFor(fullpath, params);
    return TheRouteMatch(
      route: route,
      subloc: subloc,
      fullpath: fullpath,
      params: posParams,
      queryParams: queryParams,
    );
  }

  /// for use by the Router architecture as part of the GoRouteMatch
  @override
  String toString() => 'GoRouteMatch($fullpath, $params)';

  /// expand a path w/ param slots using params, e.g. family/:fid => family/f1
  static String _locationFor(String path, Map<String, String> params) =>
      p2re.pathToFunction(path)(params);
}
