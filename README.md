# Introduction

This is a sample of API communication using retrofit.

## overview

Get a list of Qiita's latest articles.
When reaching the end of the list, additional loading occurs.

A version that uses ChangeNotifierProvider for state management.

## Flow

1.Create a screen

This time there are 3 screens: Splash, Home, and WebView.

2.Retrofit introduction

pubspec.yaml
````yaml
dependencies:
  http: ^1.2.1
  retrofit: '>=4.0.0 <5.0.0'
  logger: any  #for logging purpose
  json_annotation: ^4.8.1

dev_dependencies:
  retrofit_generator: ^8.1.0   # required dart >=2.19
  build_runner: '>=2.3.0 <4.0.0'
  json_serializable: ^6.6.2
````

3.Create a client for API communication

The part clause is the file name when generating code with build_runner.
(I think the g is probably the g for Generate)
By creating an abstract, the actual QiitaClient.g.dart will be automatically generated.

```dart
part 'QiitaClient.g.dart';

@RestApi(baseUrl: "https://qiita.com/api/")
abstract class QiitaClient {
  factory QiitaClient(Dio dio, {String baseUrl}) = _QiitaClient;

  @GET("v2/items")
  Future<List<QiitaArticle>> fetchItems(
      @Query("page") int page,
      @Query("per_page") int perPage,
      @Query("query") String? query);

}
````

4.Request/response data type definition

Prepare the container.
Again, specify the file name when generating code with build_runner.

One thing to note is that you should not write any unnecessary code before automatically generating the code.
Automatic generation may fail.

```dart
part 'QiitaArticle.g.dart';

// explicitToJson is added to enable nesting of classes
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

}
````

5.Generate the entity

Execute the following command in the terminal.

````cmd
flutter pub run build_runner build
````
A .g.dart file should have been created.

6.Implement json converter in data class

Since the converter entity is created in .g.dart, implement the factory in the original code

```dart
factory QiitaArticle.fromJson(Map<String, dynamic> json) => _$QiitaArticleFromJson(json);
Map<String, dynamic> toJson() => _$QiitaArticleToJson(this);

@override
String toString() => json.encode(toJson());

````

7.Create a repository that calls the api

It depends on the system configuration, but this time I decided to create a repository and generate an instance of Client within the repository.

```dart
abstract class QiitaRepositoryInterface {
  Future<ApiResponse> fetchItems(int page, int perPage, String? query) async {
    throw UnimplementedError();
  }
}

class QiitaRepository extends QiitaRepositoryInterface {

  final QiitaClient _client;

  QiitaRepository([QiitaClient? client]):
        _client = client ?? QiitaClient(Dio());

  @override
  Future<ApiResponse> fetchItems(int page, int perPage, String? query) async {
    return await _client.fetchItems(page, perPage, query)
        .then((value) =>  ApiResponse(ApiResponseType.ok, value))
        .catchError((e) {
          // retrofit official document
          // https://pub.dev/documentation/retrofit/latest/
          int? errorCode = 0;
          String? errorMessage = "";
          switch (e.runtimeType) {
            case DioException:
              final res = (e as DioException).response;
              if (res != null) {
                errorCode = res.statusCode;
                errorMessage = res.statusMessage;
              }
              break;
            default:
          }
          log("Got error : $errorCode -> $errorMessage");
          var apiResponseType = ApiResponse.convert(errorCode);
          return ApiResponse(apiResponseType, errorMessage);
        });
  }

}
````

8.Call it from the screen and display it in ListView.

I have modified ListView.builder so that it can be added and read in the simplest display. I enclosed it in RefreshIndicator so that pull refresh also works.

```dart
    body: RefreshIndicator(
      onRefresh:() => context.read<HomeScreenViewModel>().refresh(context),
      child: ListView.builder(
        key: const Key(WidgetKey.KEY_HOME_LIST_VIEW),
        itemBuilder: (BuildContext context, int index) {
          var length = context.read<HomeScreenViewModel>().articles.length -1;
          if (index == length) {
            // load more request
            context.read<HomeScreenViewModel>().loadMore(context);
            // loading display
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (index > length) {
            return null;
          }
          return Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child: rowWidget(context, index),
          );
        },
        itemCount: context.watch<HomeScreenViewModel>().articles.length,
      ),
    ),
````

9.Tap the title of the list to display the article in WebView


that's all