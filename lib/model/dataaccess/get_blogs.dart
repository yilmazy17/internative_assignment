// ignore: unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';

Future<Map<String, dynamic>?> getBlogs(String? catId, String type) async {
  try {
    UserController _userController = Get.find();
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ${_userController.bearerToken}'
    };

    Map<String, dynamic> inputData;
    if (catId == null) {
      inputData = {"CategoryId": null};
    } else {
      inputData = {"CategoryId": catId};
    }
    var body = json.encode(inputData);
    var url = Uri.parse(ApiProvider.blogGetBlogs);
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.body.isNotEmpty) {
      var resBody = json.decode(response.body);
      if (resBody['HasError'] == false) {
        BlogController _blogController = Get.find();
        if (type == 'fav') {
          for (var item in resBody['Data']) {
            for (var item2 in _userController.favBlogs) {
              if (item2['BlogId'] == item['Id']) {
                _blogController.blogs.add(item);
              }
            }
          }
        } else {
          for (var item in resBody['Data']) {
            _blogController.blogs.add(item);
          }
          _blogController.blogs.value.removeLast();
        }
        return {'status': true, 'Error': 'NoError'};
      } else {
        if (resBody['ValidationErrors'].length > 0) {
          return {
            'status': false,
            'Error': resBody['ValidationErrors'][0]['Value'].toString()
          };
        } else {
          return {'status': false, 'Error': resBody['Message']};
        }
      }
    } else {
      return {'status': false, 'Error': 'Web Servisler Çalışmıyor'};
    }
  } catch (e) {
    print(e);
    return {'status': false, 'Error': e.toString()};
  }
}
