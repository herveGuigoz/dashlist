import 'package:dashlist/src/core/result/result.dart';
import 'package:dashlist/src/modules/authentication/logic/interface.dart';
import 'package:dashlist/src/modules/authentication/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

class FirebaseAuthentication implements AuthenticationInterface {
  @protected
  final client = firebase.FirebaseAuth.instance;

  @override
  Future<Result<User>> register(String email, String password) async {
    return Result.guard(() async {
      await client.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return User(email: email);
    });
  }

  @override
  Future<Result<User>> signIn(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  Stream<User?> authStateChanges() {
    return client
        .userChanges()
        .map((event) => event != null ? User(email: event.email!) : null);
  }
}
