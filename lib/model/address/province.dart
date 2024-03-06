import 'package:datn/model/address/district.dart';

class Province {
  String? id;
  String? name;
  List<District>? districts;

  Province({
    required this.id,
    required this.name,
    required this.districts,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    var ditrictObjectJson = json['level2s'] as List;
    List<District> districts = ditrictObjectJson.map((districtJson) => District.fromJson(districtJson)).toList();
    return Province(
      id: json['level1_id'], 
      name: json['name'], 
      districts: districts
    );
  }

  @override
  String toString() => 'Province(id: $id, name: $name, districts: $districts)';
}
