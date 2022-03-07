// ignore: unused_import
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>?> logincheck(String? mail, String? password) async {
  try {
    String? token;
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    Map<String, dynamic> inputData = {
      "Email": mail,
      "Password": password,
    };
    var body = json.encode(inputData);
    var url = Uri.parse(ApiProvider.signIn);
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.body.isNotEmpty) {
      var resBody = json.decode(response.body);
      if (resBody['HasError'] == false) {
        String a = 'internative1234567891internative';

        final key = Key.fromUtf8(a);
        final iv = IV.fromLength(16);
        final encrypter = Encrypter(AES(key));
        String encrypted = '';
        if (password != null) {
          encrypted = encrypter.encrypt(password, iv: iv).base64;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('mail', mail!);
        prefs.setString('password', encrypted);

        token = resBody['Data']['Token'];

        UserController _user = Get.put(UserController(
          mail,
          token,
        ));
        headers = {
          'content-type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        url = Uri.parse(ApiProvider.accountGet);
        response = await http.get(url, headers: headers);
        resBody = json.decode(response.body);
        if (resBody['HasError'] == false) {
          _user.addUserId(resBody['Data']['Id']);
          _user.addImage(resBody['Data']['Image']);
          _user.addLocation(resBody['Data']['Location']);
          for (var item in resBody['Data']['FavoriteBlogIds']) {
            _user.addFavBlog({'BlogId': item.toString()});
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

Future<Map<String?, String?>?> valuecheck() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mail = prefs.getString('mail');
    String? passwordf = prefs.getString('password');
    if (mail == null || passwordf == null) {
      return null;
    } else {
      final passworden = Encrypted.fromBase64(passwordf);

      final key = Key.fromUtf8('internative1234567891internative');
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key));
      String? password = encrypter.decrypt(passworden, iv: iv).toString();

      return {'mail': mail, 'password': password};
    }
  } catch (e) {
    print(e);
    return {'username': null, 'password': null};
  }
}
