class User {
  String email;
  String name;
  String id;

  User({
    required this.email, 
    required this.name, 
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      id: map['code'] as String,
    );
  }
}
