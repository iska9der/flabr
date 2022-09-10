import '../../../common/exception/displayable_exception.dart';
import 'network/auth_response_type.dart';

class AuthException implements DisplayableException {
  final AuthFailureType type;

  AuthException(this.type);

  @override
  String toString() {
    return type.message;
  }
}
