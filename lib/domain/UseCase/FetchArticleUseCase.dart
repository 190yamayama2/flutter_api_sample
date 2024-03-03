
import 'package:flutter_api_sample/domain/api/qitta/qiita_client.dart';
import 'package:dio/dio.dart';
import '../api/api_response.dart';
import '../repository/qiita_repository.dart';

abstract class FetchArticleUseCaseInterface {
  Future<ApiResponse> fetchArticle(int page, int perPage) async {
    throw UnimplementedError();
  }
}

class FetchArticleUseCase extends FetchArticleUseCaseInterface {

  final QiitaRepositoryInterface _qiitaRepository;

  FetchArticleUseCase([QiitaRepositoryInterface? qiitaRepository]):
        _qiitaRepository = qiitaRepository ?? QiitaRepository(QiitaClient(Dio()));

  @override
  Future<ApiResponse> fetchArticle(int page, int perPage) async {
    return _qiitaRepository.fetchItems(page, perPage);
  }

}