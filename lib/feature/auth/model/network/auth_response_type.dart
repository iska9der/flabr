enum AuthFailureType { auth, captcha, unknown }

extension AuthFailureX on AuthFailureType {
  String get message {
    switch (this) {
      case AuthFailureType.auth:
        return 'Неверная почта или пароль';
      case AuthFailureType.captcha:
        return 'Нужно ввести капчу';
      case AuthFailureType.unknown:
        return 'Неизвестная ошибка';
    }
  }
}
