import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_api_sample/api/qitta/model/QiitaArticle.dart';
import 'package:flutter_api_sample/repository/QiitaRepository.dart';
import 'package:flutter_api_sample/ui/parts/Dialog.dart';
import 'package:flutter_api_sample/ui/screen/WebViewScreen.dart';

class HomeScreenViewModel with ChangeNotifier {

  final int perPage = 20; // 取得件数
  final String query = "qiita user:Qiita";

  QiitaRepository _qiitaRepository;

  int page = 1;
  List<QiitaArticle> articles = [];

  HomeScreenViewModel([QiitaRepository qiitaRepository]) {
    _qiitaRepository = qiitaRepository ?? QiitaRepository();
  }

  Future<void> fetchArticle(BuildContext context) async {
    page += 1;

    Dialogs.showLoadingDialog(context);
    notifyListeners();

    return _qiitaRepository.fetchArticle(page, perPage, query)
        .then((result) {
          if (result == null || result.statusCode != 200) {
            // ロード中のダイアログを閉じる
            Navigator.pop(context);
            Dialogs.showErrorDialog(context, result.errorMessage);
            notifyListeners();
            return;
          }

          articles.addAll(result.result);
          // ロード中のダイアログを閉じる
          Navigator.pop(context);
          notifyListeners();
          return;
        });
  }

  Future<void> loadMore(BuildContext context) async {
    page += 1;

    return _qiitaRepository.fetchArticle(page, perPage, query)
        .then((result) {
          if (result == null || result.statusCode != 200) {
            Dialogs.showErrorDialog(context, result.errorMessage);
            notifyListeners();
            return;
          }
          articles.addAll(result.result);
          notifyListeners();
          return;
        });
  }

  Future<void> refresh(BuildContext context) async {
    page = 0;
    articles.clear();
    notifyListeners();

    return fetchArticle(context);
  }

  void moveWebViewScreen(BuildContext context, int index) {
    var url = articles[index].url;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(urlString: url))
    );
  }
}