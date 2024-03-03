import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'qiita_tag.g.dart';

@JsonSerializable()
class QiitaTag {
  String name;
  List<dynamic> versions;

  QiitaTag({
    required this.name,
    required this.versions,
  });

  factory QiitaTag.fromJson(Map<String, dynamic> json) => _$QiitaTagFromJson(json);
  Map<String, dynamic> toJson() => _$QiitaTagToJson(this);

  @override
  String toString() => json.encode(toJson());

}