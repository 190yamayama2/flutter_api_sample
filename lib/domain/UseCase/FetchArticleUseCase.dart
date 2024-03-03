
import 'package:flutter_api_sample/domain/api/qitta/qiita_client.dart';
import 'package:dio/dio.dart';
import '../api/api_response.dart';
import '../repository/qiita_repository.dart';

abstract class FetchArticleUseCaseInterface {
  Future<ApiResponse> invoke(int page, int perPage, {String? query}) async {
    throw UnimplementedError();
  }
}

class FetchArticleUseCase extends FetchArticleUseCaseInterface {

  final QiitaRepositoryInterface _qiitaRepository;

  FetchArticleUseCase([QiitaRepositoryInterface? qiitaRepository]):
        _qiitaRepository = qiitaRepository ?? QiitaRepository(QiitaClient(Dio()));

  @override
  Future<ApiResponse> invoke(int page, int perPage, {String? query}) async {
    return _qiitaRepository.fetchItems(page, perPage, query: query);
  }

}