import 'package:datn/model/address/ward.dart';

class District {
  String? id;
  String? name;
  List<Ward>? wards;
  
  District({
    required this.id,
    required this.name,
    required this.wards,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    var wardObjectJson = json['level3s'] as List;
    List<Ward> wards = wardObjectJson.map((wardJson) => Ward.fromJson(wardJson)).toList();
    return District(
      id: json['level2_id'], 
      name: json['name'], 
      wards: wards
    );
  }
  
  @override
  String toString() => 'District(id: $id, name: $name, wards: $wards)';
}
