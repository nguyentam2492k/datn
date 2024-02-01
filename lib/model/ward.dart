class Ward {
  String? id;
  String? name;

  Ward({
    required this.id,
    required this.name,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['level3_id'], 
      name: json['name']
    );
  }

  @override
  String toString() => 'Ward(id: $id, name: $name)';
}
