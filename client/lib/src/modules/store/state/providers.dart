import 'dart:convert';

import 'package:client/configuration.dart';
import 'package:client/src/modules/store/state/models.dart';
import 'package:client/src/services/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _storeURL = '/stores';

final _kHeaders = {'Accept': 'Application/json'};

final _storesResponseProvider = FutureProvider<Response>((ref) async {
  final client = ref.read(httpClientProvider);
  final baseURL = ref.read(configurationProvider).baseUrl;
  return client.get(Uri.parse('$baseURL$_storeURL'), headers: _kHeaders);
});

final storesProvider = FutureProvider((ref) async {
  final response = await ref.watch(_storesResponseProvider.future);

  if (response.statusCode != 200) {
    throw Exception('Respose error with status code ${response.statusCode}');
  }

  final data = json.decode(response.body) as List<dynamic>;

  return data.map((e) => Store.fromMap(e as Map<String, dynamic>)).toList();
});

final hubProvider = FutureProvider((ref) async {
  final response = await ref.watch(_storesResponseProvider.future);
  return response.mercureHub;
});
