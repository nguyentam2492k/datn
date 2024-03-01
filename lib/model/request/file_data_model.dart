import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FileData {
  String filename;
  String url;

  FileData({
    required this.filename,
    required this.url,
  });

  factory FileData.fromJson(Map<String, dynamic> map) {
    return FileData(
      filename: map['filename'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filename': filename,
      'url': url,
    };
  }

  String toJson() => json.encode(toMap());
}
