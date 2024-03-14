class User {
  String email;
  String name;
  String id;
  String? image;

  User({
    required this.email, 
    required this.name, 
    required this.id,
    this.image
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      id: map['id'] as String,
      image: map['image'] as String?,
    );
  }
}
