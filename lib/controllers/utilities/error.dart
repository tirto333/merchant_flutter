import 'package:dio/dio.dart';
import 'package:winn_merchant_flutter/models/error.dart';

class ErrorController {
  ErrorResModel check(DioError error, String? section) {
    switch (error.type.toString().split(".")[1]) {
      case 'connectTimeout':
        return ErrorResModel.fromJson({
          "status": 500,
          "message": 'Connection Timeout',
        });
      case 'response':
        switch (error.response?.statusCode) {
          case 502:
            return ErrorResModel.fromJson({
              "status": error.response?.statusCode,
              "message": 'Terjadi Kesalahan Server 502',
            });
          case 422:
            switch (section) {
              case 'login':
                if (error.response?.data['errors'][0]?["email"] != null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]["email"],
                  });
                } else if (error.response?.data['errors'][0]?["password"] !=
                    null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]["password"],
                  });
                } else {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'].toString(),
                  });
                }
              case 'change-password':
                if (error.response?.data['errors'][0]?["old_password"] !=
                    null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]
                        ["old_password"],
                  });
                } else if (error.response?.data['errors'][0]?["new_password"] !=
                    null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]
                        ["new_password"],
                  });
                } else if (error.response?.data['errors'][0]
                        ?["confirm_password"] !=
                    null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]
                        ["confirm_password"],
                  });
                } else {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'].toString(),
                  });
                }
              case 'register':
                if (error.response?.data['errors'][0]?["email"] != null) {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'][0]["email"],
                  });
                } else {
                  return ErrorResModel.fromJson({
                    "status": error.response?.statusCode,
                    "message": error.response?.data['errors'].toString(),
                  });
                }
              default:
                return ErrorResModel.fromJson({
                  "status": error.response?.statusCode,
                  "message": error.response?.data['errors'].toString(),
                });
            }
          case 401:
            return ErrorResModel.fromJson({
              "status": error.response?.statusCode,
              "message":
                  error.response?.data['errors'][0]['message'].toString(),
            });
          default:
            return ErrorResModel.fromJson({
              "status": error.response?.statusCode,
              "message":
                  error.response?.data['errors'][0]['message'].toString(),
            });
        }
      default:
        return ErrorResModel.fromJson({
          "status": error.response?.statusCode,
          "message": error.response?.data['errors'][0]['message'].toString(),
        });
    }
  }
}
