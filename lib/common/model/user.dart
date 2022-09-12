abstract class UserBase {
  const UserBase({
    this.id = '',
    this.alias = '',
    this.fullname = '',
    this.avatarUrl = '',
  });

  final String id;
  final String alias;
  final String fullname;
  final String avatarUrl;
}
