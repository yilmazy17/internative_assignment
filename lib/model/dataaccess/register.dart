// ignore: unused_import
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>?> register(
    String? mail, String? password1, String? password2) async {
  try {
    String? token;
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    Map<String, dynamic> inputData = {
      "Email": mail,
      "Password": password1,
      "PasswordRetry": password2,
    };
    var body = json.encode(inputData);
    var url = Uri.parse(ApiProvider.signUp);
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.body.isNotEmpty) {
      var resBody = json.decode(response.body);
      if (resBody['HasError'] == false) {
        String a = 'internative1234567891internative';

        final key = Key.fromUtf8(a);
        final iv = IV.fromLength(16);
        final encrypter = Encrypter(AES(key));
        String encrypted = '';
        if (password1 != null) {
          encrypted = encrypter.encrypt(password1, iv: iv).base64;
        }
        print(a.length);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('mail', mail!);
        prefs.setString('password', encrypted);

        token = resBody['Data']['Token'];

        Get.put(UserController(
          mail,
          token,
        ));
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
