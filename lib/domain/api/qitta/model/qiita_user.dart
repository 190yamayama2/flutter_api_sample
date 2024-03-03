
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'qiita_user.g.dart';

@JsonSerializable()
class QiitaUser {
  String? description;
  @JsonKey(name: 'facebook_id')
  String? facebookId;
  @JsonKey(name: 'followees_count')
  int followeesCount;
  @JsonKey(name: 'followers_count')
  int followersCount;
  @JsonKey(name: 'github_login_name')
  String? githubLoginName;
  String id;
  @JsonKey(name: 'items_count')
  int itemsCount;
  @JsonKey(name: 'linkedin_id')
  String? linkedinId;
  String? location;
  String name;
  String? organization;
  @JsonKey(name: 'permanent_id')
  int permanentId;
  @JsonKey(name: 'profile_image_url')
  String? profileImageUrl;
  @JsonKey(name: 'team_only')
  bool teamOnly;
  @JsonKey(name: 'twitter_screen_name')
  String? twitterScreenName;
  @JsonKey(name: 'website_url')
  String? websiteUrl;

  QiitaUser({
    required this.description,
    required this.facebookId,
    required this.followeesCount,
    required this.followersCount,
    required this.githubLoginName,
    required this.id,
    required this.itemsCount,
    required this.linkedinId,
    required this.location,
    required this.name,
    required this.organization,
    required this.permanentId,
    required this.profileImageUrl,
    required this.teamOnly,
    required this.twitterScreenName,
    required this.websiteUrl,
  });

  factory QiitaUser.fromJson(Map<String, dynamic> json) => _$QiitaUserFromJson(json);
  Map<String, dynamic> toJson() => _$QiitaUserToJson(this);

  @override
  String toString() => json.encode(toJson());

  static const String anonymousUserName = "匿名ユーザ";

  get displayUserName {
    var userName = (this.name ?? "").trim().isEmpty ? anonymousUserName : "${this.name}";
    return "$userNameさん";
  }

  get followersCountString {
    if (followersCount == 0) return "-";
    return "$followersCount";
  }

}
