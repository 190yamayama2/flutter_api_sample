
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_api_sample/domain/api/api_response.dart';
import 'package:flutter_api_sample/domain/api/qitta/qiita_client.dart';
import '../api/api_respose_type.dart';

abstract class QiitaRepositoryInterface {
  Future<ApiResponse> fetchItems(int page, int perPage) async {
    throw UnimplementedError();
  }
}

class QiitaRepository extends QiitaRepositoryInterface {

  final QiitaClient _client;

  QiitaRepository([QiitaClient? client]):
        _client = client ?? QiitaClient(Dio());

  @override
  Future<ApiResponse> fetchItems(int page, int perPage) async {
    return await _client.fetchItems(page, perPage)
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