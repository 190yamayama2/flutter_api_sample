import 'package:flutter/material.dart';
import 'package:flutter_api_sample/domain/UseCase/FetchArticleUseCase.dart';
import 'package:flutter_api_sample/domain/api/qitta/model/qiita_article.dart';
import 'package:flutter_api_sample/ui/parts/dialogs.dart';
import 'package:flutter_api_sample/ui/screen/web_view_screen.dart';
import 'package:intl/intl.dart';
import '../domain/api/api_respose_type.dart';

class HomeScreenViewModel with ChangeNotifier {

  final int perPage = 20;

  FetchArticleUseCaseInterface _fetchArticleUseCase;
  DateTime now = DateTime.now();
  final myFormat = DateFormat('yyyy-MM-dd');
  int page = 1;
  List<QiitaArticle> articles = [];

  HomeScreenViewModel({required FetchArticleUseCaseInterface fetchArticleUseCase})
      : _fetchArticleUseCase = fetchArticleUseCase;

  Future<bool> fetchArticle(BuildContext context) async {
    page += 1;
    // last 3 years
    now = DateTime.now().subtract(const Duration(days: 360*3));

    final dialogs = Dialogs(context: context);
    dialogs.showLoadingDialog();
    
    return _fetchArticleUseCase.invoke(page, perPage, query: "created:>${myFormat.format(now)}")
        .then((result) {
          if (result.apiStatus.code != ApiResponseType.ok.code) {
            dialogs.closeDialog();
            dialogs.showErrorDialog(result.message);
            notifyListeners();
            return false;
          }
          articles.addAll(result.result);
          dialogs.closeDialog();
          notifyListeners();
          return true;
        });
  }

  Future<bool> loadMore(BuildContext context) async {
    page += 1;
    return _fetchArticleUseCase.invoke(page, perPage, query: "created:>${myFormat.format(now)}")
        .then((result) {
          if (result.apiStatus.code != ApiResponseType.ok.code) {
            final dialogs = Dialogs(context: context);
            dialogs.showErrorDialog(result.message);
            notifyListeners();
            return false;
          }
          articles.addAll(result.result);
          notifyListeners();
          return true;
        });
  }

  Future<bool> refresh(BuildContext context) async {
    page = 0;
    articles.clear();
    notifyListeners();
    return fetchArticle(context);
  }

  void moveWebViewScreen(BuildContext context, int index) {
    var url = articles[index].url;
    if (url == null) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(urlString: url, key: UniqueKey(),)
        )
    );
  }

  void showExitDialog(BuildContext context) {
    final dialogs = Dialogs(context: context);
    dialogs.showExitDialog();
  }

}