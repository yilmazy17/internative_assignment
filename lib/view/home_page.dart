import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/favorite.dart';
import 'package:internative_assignment/model/dataaccess/getLocation.dart';
import 'package:internative_assignment/model/dataaccess/get_blogs.dart';
import 'package:internative_assignment/model/dataaccess/logout.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  UserController _userController = Get.find();
  BlogController _blogController = Get.find();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (widget._userController.location == null) {
      getLocation(null, null);
    }

    super.initState();
  }

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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'HomePage',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                height: Get.height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () async {
                        widget._blogController.blogs.clear();
                        await getBlogs(
                            widget._blogController.categories[index]['Id'],
                            'all');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(),
                            height: 91,
                            width: 164,
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: Image.network(
                                    widget._blogController.categories[index]
                                        ['Image'],
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              widget._blogController.categories[index]['Title'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: widget._blogController.categories.length,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Blog',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(() => Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {
                                return (() {
                                  if (widget._blogController.blogs.length % 2 ==
                                      0) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(widget
                                                            ._blogController
                                                            .blogs[(index * 2)]
                                                        ['Image'])),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 5, 16),
                                              height: 266,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        await favBlog(widget
                                                                ._blogController
                                                                .blogs[
                                                            (index * 2)]['Id']);
                                                      },
                                                      icon: Obx(
                                                        () => Icon(
                                                          Icons.favorite,
                                                          color: (() {
                                                            if (checkExist(
                                                                widget
                                                                    ._userController
                                                                    .favBlogs,
                                                                widget._blogController
                                                                            .blogs[
                                                                        (index *
                                                                            2)]
                                                                    ['Id'])) {
                                                              return Colors.red;
                                                            } else {
                                                              return Colors
                                                                  .black;
                                                            }
                                                          }()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 56,
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Text(
                                                        widget._blogController
                                                                    .blogs[
                                                                (index * 2)]
                                                            ['Title'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(widget
                                                                ._blogController
                                                                .blogs[
                                                            (index * 2) + 1]
                                                        ['Image'])),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  5, 0, 0, 16),
                                              height: 266,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        await favBlog(widget
                                                                ._blogController
                                                                .blogs[
                                                            (index * 2) +
                                                                1]['Id']);
                                                      },
                                                      icon: Obx(
                                                        () => Icon(
                                                          Icons.favorite,
                                                          color: (() {
                                                            if (checkExist(
                                                                widget
                                                                    ._userController
                                                                    .favBlogs,
                                                                widget
                                                                    ._blogController
                                                                    .blogs[(index *
                                                                        2) +
                                                                    1]['Id'])) {
                                                              return Colors.red;
                                                            } else {
                                                              return Colors
                                                                  .black;
                                                            }
                                                          }()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 56,
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Text(
                                                        widget._blogController
                                                                    .blogs[
                                                                (index * 2 + 1)]
                                                            ['Title'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    if ((widget._blogController.blogs.length -
                                            1) !=
                                        ((index * 2))) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(widget
                                                              ._blogController
                                                              .blogs[
                                                          (index *
                                                              2)]['Image'])),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 5, 16),
                                                height: 266,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await favBlog(widget
                                                                  ._blogController
                                                                  .blogs[
                                                              (index *
                                                                  2)]['Id']);
                                                        },
                                                        icon: Obx(
                                                          () => Icon(
                                                            Icons.favorite,
                                                            color: (() {
                                                              if (checkExist(
                                                                  widget
                                                                      ._userController
                                                                      .favBlogs,
                                                                  widget._blogController
                                                                          .blogs[
                                                                      (index *
                                                                          2)]['Id'])) {
                                                                return Colors
                                                                    .red;
                                                              } else {
                                                                return Colors
                                                                    .black;
                                                              }
                                                            }()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 56,
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          widget._blogController
                                                                      .blogs[
                                                                  (index * 2)]
                                                              ['Title'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(widget
                                                              ._blogController
                                                              .blogs[
                                                          (index * 2) +
                                                              1]['Image'])),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 16),
                                                height: 266,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await favBlog(widget
                                                              ._blogController
                                                              .blogs[(index *
                                                                  2) +
                                                              1]['Id']);
                                                        },
                                                        icon: Obx(
                                                          () => Icon(
                                                            Icons.favorite,
                                                            color: (() {
                                                              if (checkExist(
                                                                  widget
                                                                      ._userController
                                                                      .favBlogs,
                                                                  widget
                                                                      ._blogController
                                                                      .blogs[(index *
                                                                          2) +
                                                                      1]['Id'])) {
                                                                return Colors
                                                                    .red;
                                                              } else {
                                                                return Colors
                                                                    .black;
                                                              }
                                                            }()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 56,
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          widget._blogController
                                                                  .blogs[
                                                              (index * 2) +
                                                                  1]['Title'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(widget
                                                                ._blogController
                                                                .blogs[
                                                            (index *
                                                                2)]['Image'])),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border:
                                                        Border.all(width: 0.5)),
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 16),
                                                height: 266,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await favBlog(widget
                                                                  ._blogController
                                                                  .blogs[
                                                              (index *
                                                                  2)]['Id']);
                                                        },
                                                        icon: Obx(
                                                          () => Icon(
                                                            Icons.favorite,
                                                            color: (() {
                                                              if (checkExist(
                                                                  widget
                                                                      ._userController
                                                                      .favBlogs,
                                                                  widget._blogController
                                                                          .blogs[
                                                                      (index *
                                                                          2)]['Id'])) {
                                                                return Colors
                                                                    .red;
                                                              } else {
                                                                return Colors
                                                                    .black;
                                                              }
                                                            }()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 56,
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          widget._blogController
                                                                      .blogs[
                                                                  (index * 2)]
                                                              ['Title'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                })();
                              },
                              itemCount:
                                  (widget._blogController.blogs.length % 2 == 0)
                                      ? (widget._blogController.blogs.length ~/
                                          2)
                                      : ((widget._blogController.blogs.length ~/
                                              2) +
                                          1),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

bool checkExist(var a, String Value) {
  bool result = false;
  for (var item in a) {
    if (item['BlogId'] == Value) {
      result = true;
    }
  }
  return result;
}
