import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_sample/domain/api/qitta/model/qiita_user.dart';
import 'package:flutter_api_sample/ui/widget_keys.dart';
import 'package:flutter_api_sample/viewModel/home_screen_view_model.dart';
import 'package:provider/provider.dart';
import '../../domain/UseCase/FetchArticleUseCase.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  late final HomeScreenViewModel viewModel;
  late final FetchArticleUseCaseInterface fetchArticleUseCase;

  @override
  Widget build(BuildContext context) {
    fetchArticleUseCase = FetchArticleUseCase();
    viewModel = HomeScreenViewModel(fetchArticleUseCase: fetchArticleUseCase);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: const HomeScreenPage(),
    );
  }

}

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: const Key(WidgetKey.KEY_HOME_APP_BAR),
          title: const Text(
            "Qiita 新着記事一覧",
            key: Key(WidgetKey.KEY_HOME_APP_BAR_TITLE),
          ),
          backgroundColor: Colors.greenAccent,
          leading: IconButton(
            key: const Key(WidgetKey.KEY_HOME_APP_BAR_ICON_BUTTON),
            icon: const Icon(
              Icons.search,
              key: Key(WidgetKey.KEY_HOME_APP_BAR_ICON),
            ),
            onPressed: () => context.read<HomeScreenViewModel>().refresh(context),
          ),
        ),
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
    );
  }

  Widget rowWidget(BuildContext context, int index) {
    return Wrap(
      spacing: 8.0,
      children: [
        userRow(context, index),
        postedDateRow(context, index),
        titleRow(context, index),
        tagsRow(context, index),
        lgtmRow(context, index),
      ],
    );
  }

  Widget userRow(BuildContext context, int index) {
    var article = context.read<HomeScreenViewModel>().articles[index];
    return Wrap(
        spacing: 8.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                          article.user.profileImageUrl ?? "",
                      ),
                  )
              )
          ),
          Text(
            (article.user.displayUserName ?? QiitaUser.anonymousUserName) ,
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
                "Followers",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.green
                )
            ),
          ),
          Text(
              "${article.user.followersCountString}",
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic
              )
          )
        ]
    );
  }

  Widget titleRow(BuildContext context, int index) {
    var article = context.read<HomeScreenViewModel>().articles[index];
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Wrap(
            children: [
              ElevatedButton(
                  key: Key("${WidgetKey.KEY_HOME_LIST_VIEW_ROW_TITLE}_$index"),
                  style: const ButtonStyle(),
                  onPressed: () async {
                    context.read<HomeScreenViewModel>().moveWebViewScreen(context, index);
                  },
                  child: Text(
                    article.title,
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        fontSize: 18
                    ),
                  )
              ),
            ],
          ),
        ]
    );
  }

  Widget tagsRow(BuildContext context, int index) {
    var article = context.read<HomeScreenViewModel>().articles[index];
    Color tagColor = const Color.fromRGBO(220, 220, 220, 0.5);
    var tags = article.tags.expand((tag) => {
      Container(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: tagColor),
          color: tagColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(tag.name,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black,
              backgroundColor: Color.fromRGBO(220, 220, 220, 0.5),
            )
        ),
      )
    }).toList();

    return Wrap(
        spacing: 8.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: tags
    );
  }

  Widget postedDateRow(BuildContext context, int index) {
    var article = context.read<HomeScreenViewModel>().articles[index];
    return Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "${article.createdAtString}に投稿しました.",
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          )
        ]
    );
  }

  Widget lgtmRow(BuildContext context, int index) {
    var article = context.read<HomeScreenViewModel>().articles[index];
    var lgtmColor = Colors.green;
    return Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: lgtmColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
                "LGTM",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: lgtmColor,
                )
            ),
          ),
          Text(
              article.likesCountString,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              )
          ),
        ]
    );
  }

}
