import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class FirestoreService<T> {
  /// The Firestore path for this collection.
  String get path;

  T decode(String id, Map<String, dynamic> json);

  Map<String, dynamic> encode(T value);

  @protected
  CollectionReference get reference {
    return FirebaseFirestore.instance.collection('shopping_lists');
  }

  Stream<List<T>> get sse async* {
    await for (final chunk in reference.snapshots()) {
      yield [
        for (final document in chunk.docs)
          decode(document.id, document.data()! as Map<String, dynamic>)
      ];
    }
  }

  Future<void> createDocument(String id, T value) async {
    await reference.doc(id).set(encode(value));
  }

  Future<List<T>> readDocuments() async {
    final collection = await reference.get();
    return [
      for (final document in collection.docs)
        decode(document.id, document.data()! as Map<String, dynamic>)
    ];
  }

  Future<void> updateDocument(String id, T value) async {
    await reference.doc(id).update(encode(value));
  }

  Future<void> deleteDocument(String id) async {
    await reference.doc(id).delete();
  }
}
