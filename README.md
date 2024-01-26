# はじめに

リカバリコードを失ったので自分のコードをフォークしました。。

## 概要

Qiitaの最新記事の一覧を取得する。
一覧の最後まで行くと追加読み込みを発生させる。

状態管理にはChangeNotifierProviderを採用したバージョン。

## 流れ

1.画面を作る

　今回はスプラッシュ・ホーム・WebViewの3画面構成

2.retrofit導入

pubspec.yaml
```yaml
dependencies:
  http: any
  retrofit: ^1.3.4
  json_annotation: ^3.0.1

dev_dependencies:
  retrofit_generator: any
  json_serializable: any
  build_runner: any
```

3.API通信のクライアントを作成

　part句はbuild_runnerでコードを生成する時のファイル名。
　（多分gはGenerateのgだと思う）
　abstractを作ることによって、実体のQiitaClient.g.dartを自動生成してくれる。

```dart
part 'QiitaClient.g.dart';

@RestApi(baseUrl: "https://qiita.com/api")
abstract class QiitaClient {
  factory QiitaClient(Dio dio, {String baseUrl}) = _QiitaClient;

  @GET("/v2/items")
  Future<List<QiitaArticle>> fetchItems(
      @Field("page") int page,
      @Field("per_page") int perPage,
      @Field("query") String query);

}
```

4.リクエスト・レスポンスのデータ型定義

　入れ物を準備します。
　ここでもbuild_runnerでコードを生成する時のファイル名を指定する。

　一つ注意事項としてコード自動生成前は余計なコードを書いておかないこと。
　自動生成に失敗することがあります。
 
```dart
part 'QiitaArticle.g.dart';

// explicitToJsonはクラスの入れ子を可能にするためつけてる
@JsonSerializable(explicitToJson: true)
class QiitaArticle {
  @JsonKey(name: 'rendered_body')
  String renderedBody;
  String body;
  bool coediting;
  @JsonKey(name: 'comments_count')
  int commentsCount;
  @JsonKey(name: 'created_at')
  String createdAt;
  String group;
  String id;
  @JsonKey(name: 'likes_count')
  int likesCount;
  bool private;
  @JsonKey(name: 'reactions_count')
  int reactionsCount;
  List<QiitaTag> tags;
  String title;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  String url;
  QiitaUser user;
  @JsonKey(name: 'page_views_count')
  int pageViewsCount;

  QiitaArticle({
    this.renderedBody,
    this.body,
    this.coediting,
    this.commentsCount,
    this.createdAt,
    this.group,
    this.id,
    this.likesCount,
    this.private,
    this.reactionsCount,
    this.tags,
    this.title,
    this.updatedAt,
    this.url,
    this.user,
    this.pageViewsCount,
  });

}
```

5.実体をgenerateする

　ターミナルで以下のコマンドを実行。

```cmd
flutter pub run build_runner build
```
　.g.dartファイルが作成されているはず。

6.データクラスにjsonコンバータを実装する

　.g.dartにコンバータの実体ができるので元のコードにfactoryを実装する

```dart
factory QiitaArticle.fromJson(Map<String, dynamic> json) => _$QiitaArticleFromJson(json);
Map<String, dynamic> toJson() => _$QiitaArticleToJson(this);

@override
String toString() => json.encode(toJson());

```

7.apiを呼び出すrepository作る

　システムの構成によりけりですが、今回はrepositoryを作成してrepositoryの中でClientのインスタンスを生成することにした。

```dart
class QiitaRepository {

  final QiitaClient _client;

  QiitaRepository({QiitaClient client}):
        _client = client ?? QiitaClient(Dio())
  ;

  Future<List<QiitaArticle>> fetchArticle(int page, int perPage, String query) async {
    return await _client.fetchItems(page, perPage, query)
        .then((value) => value)
        .catchError((e) {
          log(e);
          return [];
        });
  }
}
```

8.画面から呼び出すしてListViewで表示する。

　最も簡単な表示で一応追加読み込みできるようにListView.builderで細工してます。プルリフレッシュも効くようにRefreshIndicatorで囲みました。

```dart
RefreshIndicator(
  child: ListView.builder(
    itemBuilder: (BuildContext context, int index) {

      var length = context.read<HomeScreenViewModel>().articles.length -1;
      if (index == length) {
        // 追加読み込み
        context.read<HomeScreenViewModel>().fetchArticle();
        // 画面にはローディング表示しておく
        return new Center(
          child: new Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          ),
        );
      } else if (index > length) {
        // ローディング表示より先は無し
        return null;
      }

      return Container(
        child: rowWidget(context, index),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
      );
    },
    itemCount: context.watch<HomeScreenViewModel>().articles.length,
  ),
  onRefresh: () => context.read<HomeScreenViewModel>().refresh(),
)
```

9.一覧のタイトルをタップでWebViewで記事を表示する


以上
