enum AuthFailureType { auth, captcha, unimplemented, unknown }

extension AuthFailureX on AuthFailureType {
  String get message => switch (this) {
        AuthFailureType.auth => 'Неверная почта или пароль',
        AuthFailureType.captcha => 'Нужно ввести капчу',
        AuthFailureType.unimplemented => 'Не реализовано',
        AuthFailureType.unknown => 'Неизвестная ошибка'
      };
}
