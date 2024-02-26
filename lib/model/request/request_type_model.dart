// ignore_for_file: public_member_api_docs, sort_constructors_first
class Request1Model {
  String certificateType;
  String quantityViet;
  String quantityEng;
  String reason;

  Request1Model({
    required this.certificateType,
    required this.quantityViet,
    required this.quantityEng,
    required this.reason,
  });

  factory Request1Model.fromJson(Map<String, dynamic> json) => Request1Model(
    certificateType: json["certificate_type"],
    quantityViet: json["quantity_viet"],
    quantityEng: json["quantity_eng"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "certificate_type": certificateType,
    "quantity_viet": quantityViet,
    "quantity_eng": quantityEng,
    "reason": reason,
  };

  @override
  String toString() {
    return 'Request1Model(certificateType: $certificateType, quantityViet: $quantityViet, quantityEng: $quantityEng, reason: $reason)';
  }
}
