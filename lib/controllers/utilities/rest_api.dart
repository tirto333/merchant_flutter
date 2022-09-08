// import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winn_merchant_flutter/config/config.dart';
import 'package:dio/dio.dart';

import 'error.dart';

String urlBased = Config.baseUrl;
String prefixBased = Config.prefixUrl;

class RestApi extends GetxController {
  // Url List
  String auth = urlBased + prefixBased + '/auth';
  String user = urlBased + prefixBased + '/merchant';
  String banner = urlBased + prefixBased + '/banner';
  String product = urlBased + prefixBased + '/product';
  String promotion = urlBased + prefixBased + '/promotion';
  String region = urlBased + prefixBased + '/region';
  String article = urlBased + prefixBased + '/article';
  String cart = urlBased + prefixBased + '/cart';
  String video = urlBased + prefixBased + '/tutorial';
  String content = urlBased + '/uploads';
  String warranty = urlBased + prefixBased + '/warranty';
  String payment = urlBased + prefixBased + '/payment';
  String chat = urlBased + prefixBased + '/chat';
  String _return = urlBased + prefixBased + '/return';

  // Initiate Import
  GetStorage token = GetStorage('token');
  Dio dio = new Dio(new BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 10 * 1000,
    receiveTimeout: 10 * 1000,
  ));
  late String? accessToken;

  void onInit() {
    accessToken = token.read('access');
    print("tokennya");
    print(accessToken);
    super.onInit();
  }

  void saveToken({var tokenData}) {
    token.write('access', tokenData);
    update();
  }

  void updateToken({var token}) {
    accessToken = token;
    update();
  }

  void clearToken() {
    token.erase();
    accessToken = '';
  }

  Future dynamicGet({
    String? endpoint,
    String? page,
    String? contentType,
    String? section,
  }) async {
    try {
      String? url;
      switch (section) {
        case 'cart':
          url = cart;
          break;
        case 'article':
          url = article;
          break;
        case 'region':
          url = region;
          break;
        case 'banner':
          url = banner;
          break;
        case 'product':
          url = product;
          break;
        case 'user':
          url = user;
          break;
        case 'promotion':
          url = promotion;
          break;
        case 'video':
          url = video;
          break;
        case 'warranty':
          url = warranty;
          break;
        case 'chat':
          url = chat;
          break;
        case 'return':
          url = _return;
          break;
        default:
      }
      // print("url : REST API ${url}$endpoint");
      // print('$url$endpoint');
      print("++++++++++++++++++++++++++++++++++++++++");
      print("DYNAMIC GET $url$endpoint");
      print("++++++++++++++++++++++++++++++++++++++++");

      var response = await dio.get(
        '$url$endpoint',
        options: Options(
          headers: {
            "Content-type": contentType,
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      // print("response rest_api");
      print("url : response rest_api_url ${url}$endpoint");
      print("hasil response : $response");
      return response;
    } on DioError catch (e) {
      print(e);
      print("ERROR DISINI NICH ${e.message}");
      throw ErrorController().check(e, page);
    }
  }

  Future dynamicUpdate({
    String? endpoint,
    String? page,
    var data,
    String? contentType,
    String? section,
  }) async {
    try {
      String? url;

      switch (section) {
        case 'cart':
          url = cart;
          break;
        case 'product':
          url = product;
          break;
        case 'user':
          url = user;
          break;
        default:
      }

      print("URL $url $endpoint");
      print("TOKEN $accessToken");
      // print(jsonEncode(data));
      print(data);
      var response = await dio.put(
        '$url$endpoint',
        data: data,
        options: Options(
          headers: {
            "Content-type": contentType,
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      print("ERROR NYA KNAPA NI $response");

      return response;
    } on DioError catch (e) {
      print("MASUK SINI UPDATE");
      throw ErrorController().check(e, page);
    }
  }

  Future dynamicPost({
    String? endpoint,
    String? page,
    var data,
    String? contentType,
    String? section,
  }) async {
    try {
      String? url;

      switch (section) {
        case 'cart':
          url = cart;
          break;
        case 'product':
          url = product;
          break;
        case 'user':
          url = user;
          break;
        case 'warranty':
          url = warranty;
          break;
        case 'payment':
          url = payment;
          break;
        case 'chat':
          url = chat;
          break;
        case 'return':
          url = _return;
          break;
        default:
      }

      var response = await dio.post(
        '$url$endpoint',
        data: data,
        options: Options(
          headers: {
            "Content-type": contentType,
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      print("Error POST :> ${e.response}");
      throw ErrorController().check(e, page);
    }
  }

  Future authPost({
    String? endpoint,
    var data,
    String? page,
    String? contentType,
  }) async {
    try {
      var response = await dio.post(
        '$auth$endpoint',
        data: data,
        options: Options(
          headers: {
            "Content-type": "$contentType",
          },
        ),
      );

      print("RESPON AUTH $response");
      print("++++++++++++++++++++++++++++++++++++++++");
      print("AUTH POST $auth$endpoint");
      print("++++++++++++++++++++++++++++++++++++++++");
      return response;
    } on DioError catch (e) {
      print("Error DISINI ${e.response}");
      throw ErrorController().check(e, page);
    }
  }

  Future dynamicDelete({
    String? endpoint,
    String? page,
    var data,
    String? contentType,
    String? section,
  }) async {
    try {
      String? url;

      switch (section) {
        case 'cart':
          url = cart;
          break;
        case 'product':
          url = product;
          break;
        case 'user':
          url = user;
          break;
        default:
      }

      var response = await dio.delete(
        '$url$endpoint',
        data: data,
        options: Options(
          headers: {
            "Content-type": contentType,
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw ErrorController().check(e, page);
    }
  }
}
