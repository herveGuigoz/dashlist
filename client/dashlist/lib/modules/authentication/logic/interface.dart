import 'package:dashlist/core/result/result.dart';
import 'package:dashlist/modules/modules.dart';

abstract class AuthenticationInterface {
  Future<Result<User>> register(String email, String password);

  Future<Result<User>> signIn(String email, String password);
}
