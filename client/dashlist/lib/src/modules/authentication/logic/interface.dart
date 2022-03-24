import 'package:dashlist/src/core/result/result.dart';
import 'package:dashlist/src/modules/authentication/models/user.dart';

abstract class AuthenticationInterface {
  Future<Result<User>> register(String email, String password);

  Future<Result<User>> signIn(String email, String password);
}
