import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internative_assignment/view/blog_detail_page.dart';
import 'package:internative_assignment/view/favorites_page.dart';
import 'package:internative_assignment/view/home_page.dart';
import 'package:internative_assignment/view/login_page.dart';
import 'package:internative_assignment/view/profile_page.dart';
import 'package:internative_assignment/view/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      //fallbackLocale: Locale('en', 'US'),
      title: 'InternativeAssignment',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      builder: EasyLoading.init(),
      getPages: [
        GetPage(name: '/loginpage', page: () => LoginPage()),
        GetPage(name: '/regispage', page: () => RegisPage()),
        GetPage(name: '/homepage', page: () => HomePage()),
        GetPage(name: '/favoritepage', page: () => FavoritesPage()),
        GetPage(name: '/profilepage', page: () => ProfilePage()),
        GetPage(name: '/blogdetailpage', page: () => BlogDetailPage()),
      ],
    );
  }
}
