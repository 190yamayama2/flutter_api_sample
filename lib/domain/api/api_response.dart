
import 'api_respose_type.dart';

class ApiResponse {

  final ApiResponseType apiStatus;
  final dynamic result;
  final String? _customMessage;

  // カスタムメッセージが指定されている場合はそっちを返却
  // そうじゃない場合はエラーコードで決まったメッセージを返却
  get message {
    if (_customMessage != null && _customMessage.isNotEmpty)
      return _customMessage;
    return this.apiStatus.message;
  }

  ApiResponse(this.apiStatus, this.result, [this._customMessage]);

  static ApiResponseType convert(int? statusCode) {
    if (statusCode == null) {
      return ApiResponseType.other;
    }
    if (statusCode == ApiResponseType.ok.code) {
      return ApiResponseType.ok;
    } else if (statusCode == ApiResponseType.badRequest.code) {
      return ApiResponseType.badRequest;
    } else if (statusCode == ApiResponseType.forbidden.code) {
      return ApiResponseType.forbidden;
    } else if (statusCode == ApiResponseType.notFound.code) {
      return ApiResponseType.notFound;
    } else if (statusCode == ApiResponseType.methodNotAllowed.code) {
      return ApiResponseType.methodNotAllowed;
    } else if (statusCode == ApiResponseType.conflict.code) {
      return ApiResponseType.conflict;
    } else if (statusCode == ApiResponseType.internalServerError.code) {
      return ApiResponseType.internalServerError;
    } else {
      return ApiResponseType.other;
    }
  }

}
