import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'model/qiita_article.dart';
part 'qiita_client.g.dart';

// https://pub.dev/packages/retrofit
// generate command
// # dart
// dart pub run build_runner build
//
// # flutter
// flutter pub run build_runner build
//

@RestApi(baseUrl: "https://qiita.com/api/")
abstract class QiitaClient {
  factory QiitaClient(Dio dio, {String baseUrl}) = _QiitaClient;

  @GET("v2/items")
  Future<List<QiitaArticle>> fetchItems(
      @Query("page") int page,
      @Query("per_page") int perPage);

}