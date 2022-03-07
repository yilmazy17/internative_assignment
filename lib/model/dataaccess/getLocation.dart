import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get/instance_manager.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/api_provider.dart';

Future<Map<String, dynamic>?> getLocation(
    String? Longtitude, String? Latitude) async {
  try {
    ;
    Map<String, dynamic> inputData;
    if (Longtitude == null || Latitude == null) {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      inputData = {
        "Image": null,
        "Location": {"Longtitude": longitude, "Latitude": latitude}
      };
    } else {
      inputData = {
        "Image": null,
        "Location": {"Longtitude": Longtitude, "Latitude": Latitude}
      };
    }
    UserController _userController = Get.find();
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ${_userController.bearerToken}'
    };

    var body = json.encode(inputData);
    var url = Uri.parse(ApiProvider.accountUpdate);
    http.Response response = await http.post(url, headers: headers, body: body);
    var resBody = json.decode(response.body);
    if (resBody['HasError'] == true) {
      EasyLoading.showError('Konum Güncelleme Hatası - ${resBody['Message']}',
          duration: Duration(seconds: 2), dismissOnTap: true);
      return {
        'status': false,
        'Error': 'Konum Güncelleme Hatası - ${resBody['Message']}'
      };
    } else {
      url = Uri.parse(ApiProvider.accountGet);
      response = await http.get(url, headers: headers);
      resBody = json.decode(response.body);
      if (resBody['HasError'] == false) {
        _userController.addLocation(resBody['Data']['Location']);
        return {'status': true, 'Error': 'NoError'};
      } else {
        return {'status': true, 'Error': resBody['Message']};
      }
    }
  } catch (e) {
    print(e.toString());
    EasyLoading.showError('Konum Verisi Güncellenemedi - ${e.toString()}',
        duration: Duration(seconds: 5), dismissOnTap: true);
    return {'status': false, 'Error': e.toString()};
  }
}
