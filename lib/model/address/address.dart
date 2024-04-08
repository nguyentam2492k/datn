class Address {
  String? province;
  String? district;
  String? ward;

  Address({
    this.province,
    this.district,
    this.ward,
  });

  @override
  String toString() => 'Address(province: $province, district: $district, ward: $ward)';
}