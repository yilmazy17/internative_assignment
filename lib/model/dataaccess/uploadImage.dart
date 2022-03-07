// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';

Future<Map<String, dynamic>?> uploadImage(String filePath) async {
  try {
    UserController _userController = Get.find();
    Map<String, String> headers = {
      'content-type': 'multipart/form-data',
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer ${_userController.bearerToken}'
    };
    var url = Uri.parse(ApiProvider.uploadImage);
    var request = new http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', filePath);
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      String reply = await response.stream.transform(utf8.decoder).join();
      var resBody = json.decode(reply);
      var inputData = {
        "Image": resBody['Data'],
        "Location": _userController.location,
      };
      headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer ${_userController.bearerToken}'
      };
      print(inputData);
      var body = json.encode(inputData);
      var apiurl = Uri.parse(ApiProvider.accountUpdate);
      var apiresponse = await http.post(apiurl, headers: headers, body: body);
      resBody = json.decode(apiresponse.body);
      if (resBody['HasError'] == false) {
        return {'status': true, 'Error': 'NoError'};
      } else {
        return {'status': false, 'Error': resBody['Message']};
      }
    } else {
      return {'status': false, 'Error': 'Resim Boyutu Büyük'};
    }
  } catch (e) {
    print(e);
    return {'status': false, 'Error': e.toString()};
  }
}
