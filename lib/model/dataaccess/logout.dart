import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/obscure_text_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<bool> logout() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Get.delete<UserController>();
    await Get.delete<BlogController>();
    await Get.delete<ObscureText>();
    await prefs.remove('mail');
    await prefs.remove('password');

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
