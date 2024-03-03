# Introduction

This is a sample of API communication using retrofit.

## overview

Get a list of Qiita's latest articles.
When reaching the end of the list, additional loading occurs.

A version that uses ChangeNotifierProvider for state management.

## Flow

1. Create a screen

This time there are 3 screens: Splash, Home, and WebView.

2.Retrofit introduction

pubspec.yaml
````yaml
dependencies:
   http: any
   retrofit: ^1.3.4
   json_annotation: ^3.0.1

dev_dependencies:
   retrofit_generator: any
   json_serializable: any
   build_runner: any
````

3. Create a client for API communication

The part clause is the file name when generating code with build_runner.
(I think the g is probably the g for Generate)
By creating an abstract, the actual QiitaClient.g.dart will be automatically generated.

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
````

5. Generate the entity

Execute the following command in the terminal.

````cmd
flutter pub run build_runner build
````
A .g.dart file should have been created.

6. Implement json converter in data class

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
class QiitaRepository {

   final QiitaClient _client;

   QiitaRepository([QiitaClient? client]):
         _client = client ?? QiitaClient(Dio());

   Future<List<QiitaArticle>> fetchItems(int page, int perPage, String query) async {
     return await _client.fetchItems(page, perPage, query)
         .then((value) => value)
         .catchError((e) {
           log(e);
           return [];
         });
   }
}
````

8. Call it from the screen and display it in ListView.

I have modified ListView.builder so that it can be added and read in the simplest display. I enclosed it in RefreshIndicator so that pull refresh also works.

```dart
RefreshIndicator(
   child: ListView.builder(
     itemBuilder: (BuildContext context, int index) {
       var length = context.read<HomeScreenViewModel>().articles.length -1;
       if (index == length) {
         // Additional loading
         context.read<HomeScreenViewModel>().fetchArticle();
         // Show loading on screen
         return new Center(
           child: new Container(
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
````

9.Tap the title of the list to display the article in WebView


that's all