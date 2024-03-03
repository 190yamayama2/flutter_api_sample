import 'dart:convert';
import 'package:flutter_api_sample/domain/api/converter/custom_date_time_converter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'qiita_tag.dart';
import 'qiita_user.dart';
part 'qiita_article.g.dart';

@CustomDateTimeConverter()
@JsonSerializable(explicitToJson: true)
class QiitaArticle {
  @JsonKey(name: 'rendered_body')
  String renderedBody;
  String body;
  bool coediting;
  @JsonKey(name: 'comments_count')
  int commentsCount;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  String? group;
  String id;
  @JsonKey(name: 'likes_count')
  int likesCount;
  bool private;
  @JsonKey(name: 'reactions_count')
  int reactionsCount;
  @JsonKey(name: 'stocks_count')
  int stocksCount;
  List<QiitaTag> tags;
  String title;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  String? url;
  QiitaUser user;
  @JsonKey(name: 'page_views_count')
  int? pageViewsCount;
  @JsonKey(name: 'team_membership')
  String? teamMemberShip;
  @JsonKey(name: 'organization_url_name')
  String? organizationUrlName;
  bool slide;

  QiitaArticle({
    required this.renderedBody,
    required this.body,
    required this.coediting,
    required this.commentsCount,
    required this.createdAt,
    required this.group,
    required this.id,
    required this.likesCount,
    required this.private,
    required this.reactionsCount,
    required this.stocksCount,
    required this.tags,
    required this.title,
    required this.updatedAt,
    required this.url,
    required this.user,
    required this.pageViewsCount,
    required this.teamMemberShip,
    required this.organizationUrlName,
    required this.slide,
  });

  factory QiitaArticle.fromJson(Map<String, dynamic> json) => _$QiitaArticleFromJson(json);
  Map<String, dynamic> toJson() => _$QiitaArticleToJson(this);

  @override
  String toString() => json.encode(toJson());

  static const String ymd = "yyyy/MM/dd(E) HH:mm";
  static const String localJp = "ja_JP";

  get createdAtString {
    return createdAt.parseString(ymd, localJp);
  }

  get updatedAtString {
    updatedAt.parseString(ymd, localJp);
  }

  get likesCountString {
    if (likesCount == 0) return "-";
    return "$likesCount";
  }

}

extension DateTimeExtension on DateTime {

  String parseString(String formatterString, String local) {
    initializeDateFormatting(local);
    var formatter = DateFormat(formatterString, local);
    var formatted = formatter.format(this); // DateからString
    return formatted;
  }

}