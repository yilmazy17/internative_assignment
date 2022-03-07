import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/obscure_text_controller.dart';
import 'package:internative_assignment/model/dataaccess/get_blogs.dart';
import 'package:internative_assignment/model/dataaccess/get_categories.dart';
import 'package:internative_assignment/model/dataaccess/register.dart';
import 'package:internative_assignment/view/materials/buttons.dart';

class RegisPage extends StatefulWidget {
  RegisPage({Key? key}) : super(key: key);

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  String? _mail;
  ObscureText _obscureText = Get.find();
  String? _password1;
  String? _password2;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.grey[350]),
                  margin: EdgeInsets.all(20),
                  width: Get.width * 0.6,
                  height: Get.height * 0.25,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: Get.width * 0.9,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            width: Get.width * 0.85,
                            height: 56,
                            child: TextFormField(
                              controller: TextEditingController(text: _mail),
                              onSaved: (value) {
                                _mail = value;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.local_post_office,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 2, color: Colors.black)),
                              width: Get.width * 0.85,
                              height: 56,
                              child: Obx(
                                () => TextFormField(
                                  obscureText: _obscureText
                                      .obscureValueLoginRegister.value,
                                  onSaved: (value) {
                                    _password1 = value;
                                  },
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (_obscureText
                                                .obscureValueLoginRegister
                                                .value ==
                                            true) {
                                          _obscureText.obscureValueLoginRegister
                                              .value = false;
                                        } else {
                                          _obscureText.obscureValueLoginRegister
                                              .value = true;
                                        }
                                      },
                                      icon: Icon(
                                        _obscureText
                                                .obscureValueLoginRegister.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'Password',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 2, color: Colors.black)),
                              width: Get.width * 0.85,
                              height: 56,
                              child: Obx(
                                () => TextFormField(
                                  obscureText: _obscureText
                                      .obscureValueLoginRegister.value,
                                  onSaved: (value) {
                                    _password2 = value;
                                  },
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if (_obscureText
                                                .obscureValueLoginRegister
                                                .value ==
                                            true) {
                                          _obscureText.obscureValueLoginRegister
                                              .value = false;
                                        } else {
                                          _obscureText.obscureValueLoginRegister
                                              .value = true;
                                        }
                                      },
                                      icon: Icon(
                                        _obscureText
                                                .obscureValueLoginRegister.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'Re-Password',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: Get.width * 0.85,
                            height: 56,
                            child: LoginRegisterButton(
                                text_color: Colors.white,
                                background_color: Color(0xff292F3B),
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                                textValue: 'Login',
                                method: () async {
                                  _obscureText.obscureValueLoginRegister.value =
                                      true;
                                  Get.offNamed('/loginpage');
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: Get.width * 0.85,
                            height: 56,
                            child: LoginRegisterButton(
                                text_color: Colors.black,
                                background_color: Colors.white,
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.black,
                                ),
                                textValue: 'Register',
                                method: () async {
                                  _formKey.currentState!.save();
                                  if (_mail == '' ||
                                      _mail == null ||
                                      _password1 == '' ||
                                      _password1 == null ||
                                      _password2 == '' ||
                                      _password2 == null) {
                                    EasyLoading.showError(
                                        'Lütfen Bütün Alanları Doldurunuz',
                                        duration: Duration(seconds: 1),
                                        dismissOnTap: true);
                                  } else {
                                    EasyLoading.show(status: 'Kayıt Olunuyor');
                                    var result = await register(
                                        _mail, _password1, _password2);
                                    if (result!['status'] == true) {
                                      if (result['Error'] != 'NoError') {
                                        EasyLoading.showError(
                                            'Kayıt Başarılı fakat Kullanıcı Bilgileri Alınamadı, tekrar deneyiniz',
                                            duration: Duration(seconds: 2),
                                            dismissOnTap: true);
                                      } else {
                                        Get.put(BlogController());
                                        EasyLoading.showSuccess(
                                            'Kayıt Başarılı',
                                            duration: Duration(seconds: 2),
                                            dismissOnTap: true);
                                        var catResult = await getCategories();
                                        if (catResult!['status'] == true) {
                                          EasyLoading.show(
                                              status: 'Bloglar Yükleniyor');
                                          var blogResult =
                                              await getBlogs(null, 'all');
                                          if (blogResult!['status'] == true) {
                                            EasyLoading.dismiss();
                                            Get.toNamed('/homepage');
                                          } else {
                                            EasyLoading.showError(
                                                'Giriş Başarılı fakat Blog Verileri Alınamadı, tekrar deneyiniz',
                                                duration: Duration(seconds: 2),
                                                dismissOnTap: true);
                                          }
                                        } else {
                                          EasyLoading.showError(
                                              'Kayıt Başarılı fakat Blog Verileri Alınamadı, tekrar deneyiniz',
                                              duration: Duration(seconds: 2),
                                              dismissOnTap: true);
                                        }
                                      }
                                    } else {
                                      EasyLoading.showError(result['Error'],
                                          duration: Duration(seconds: 1),
                                          dismissOnTap: true);
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
