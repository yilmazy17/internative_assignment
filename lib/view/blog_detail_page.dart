import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';

import 'package:internative_assignment/model/dataaccess/get_blogs.dart';

import 'package:flutter_html/flutter_html.dart';

class BlogDetailPage extends StatefulWidget {
  BlogDetailPage({Key? key}) : super(key: key);

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
  UserController _userController = Get.find();
  BlogController _blogController = Get.find();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => InkWell(
                onTap: () async {
                  EasyLoading.show(status: 'Favoriler Yükleniyor');
                  widget._blogController.blogs.clear();
                  await getBlogs(null, 'fav');
                  EasyLoading.dismiss();
                  Get.toNamed('/favoritepage');
                },
                child: Container(
                  height: 35,
                  width: 35,
                  child: Badge(
                      badgeContent: Text(
                          widget._userController.favBlogs.length.toString()),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 32,
                      )),
                ),
              )),
          Icon(
            Icons.home,
            size: 32,
          ),
          IconButton(
              onPressed: () {
                Get.toNamed('/profilepage');
              },
              icon: Icon(
                Icons.person,
                color: Colors.grey,
                size: 32,
              )),
        ],
      )),
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'Article Detail',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(13),
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Title(
                    color: Colors.black,
                    child: Text(
                      widget._blogController.blogDetail['Title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Html(
                  data: widget._blogController.blogDetail['Content'],
                  style: {
                    ".": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    // tables will have the below background color
                    "table": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    // some other granular customizations are also possible
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topLeft,
                    ),
                    // text that renders h1 elements will be red
                    "h1": Style(color: Colors.red),
                  },
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
