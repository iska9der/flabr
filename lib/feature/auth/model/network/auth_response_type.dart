enum AuthFailureType { auth, captcha, unknown }

extension AuthFailureX on AuthFailureType {
  String get message => switch (this) {
        AuthFailureType.auth => 'Неверная почта или пароль',
        AuthFailureType.captcha => 'Нужно ввести капчу',
        AuthFailureType.unknown => 'Неизвестная ошибка'
      };
}
