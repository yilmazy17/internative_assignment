// ignore: unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';

Future<Map<String, dynamic>?> favBlog(String blogId) async {
  try {
    UserController _userController = Get.find();
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ${_userController.bearerToken}'
    };

    Map<String, dynamic> inputData = {"Id": blogId};

    var body = json.encode(inputData);
    var url = Uri.parse(ApiProvider.blogFav);
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.body.isNotEmpty) {
      var resBody = json.decode(response.body);
      if (resBody['HasError'] == false) {
        url = Uri.parse(ApiProvider.accountGet);
        response = await http.get(url, headers: headers);
        resBody = json.decode(response.body);
        if (resBody['HasError'] == false) {
          _userController.favBlogs.clear();
          for (var item in resBody['Data']['FavoriteBlogIds']) {
            _userController.addFavBlog({'BlogId': item.toString()});
          }
          return {'status': true, 'Error': 'NoError'};
        } else {
          return {'status': true, 'Error': resBody['Message']};
        }
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
