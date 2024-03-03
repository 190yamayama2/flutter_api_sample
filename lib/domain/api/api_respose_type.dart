enum ApiResponseType {
  ok,
  badRequest,
  forbidden,
  notFound,
  methodNotAllowed,
  conflict,
  internalServerError,
  other,
}

extension ApiErrorTypeExtension on ApiResponseType {

  get code {
    switch (this) {
      case ApiResponseType.ok:
        return 200;
      case ApiResponseType.badRequest:
        return 400;
      case ApiResponseType.forbidden:
        return 403;
      case ApiResponseType.notFound:
        return 404;
      case ApiResponseType.methodNotAllowed:
        return 405;
      case ApiResponseType.conflict:
        return 409;
      case ApiResponseType.internalServerError:
        return 500;
      default:
        return null;
    }
  }

  get message {
    switch (this) {
      case ApiResponseType.ok:
        return "";
      case ApiResponseType.badRequest:
        return "引数が無効です";
      case ApiResponseType.forbidden:
        return "オブジェクトを操作する権限がない為、操作できません。";
      case ApiResponseType.notFound:
        return "パスで参照されたオブジェクトは存在しません。";
      case ApiResponseType.methodNotAllowed:
        return "メソッドがパスに許可されているメソッドの1つではありません。";
      case ApiResponseType.conflict:
        return "すでに存在するオブジェクトを作成しようとしました。";
      case ApiResponseType.internalServerError:
        return "サービスの実行が何らかの原因で失敗しました。";
      default:
        return "サービスの実行が何らかの原因で失敗しました。";
    }
  }
}