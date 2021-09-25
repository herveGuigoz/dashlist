import 'dart:convert';

import 'package:client/src/modules/books/state/models.dart';
import 'package:client/src/services/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _booksURL = 'https://localhost/books';

final _kHeaders = {'Accept': 'Application/json'};

final _booksResponseProvider = FutureProvider<Response>((ref) async {
  final client = ref.read(httpClientProvider);
  return client.get(Uri.parse(_booksURL), headers: _kHeaders);
});

final booksProvider = FutureProvider((ref) async {
  final response = await ref.watch(_booksResponseProvider.future);

  if (response.statusCode != 200) {
    throw Exception('Respose error with status code ${response.statusCode}');
  }

  final data = json.decode(response.body) as List<dynamic>;

  return data.map((e) => Book.fromMap(e as Map<String, dynamic>)).toList();
});

// todo play with response.headers['etag']
final hubProvider = FutureProvider((ref) async {
  final response = await ref.watch(_booksResponseProvider.future);
  return response.mercureHub;
});
