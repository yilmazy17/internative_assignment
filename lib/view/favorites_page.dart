import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:internative_assignment/model/dataaccess/favorite.dart';
import 'package:internative_assignment/model/dataaccess/get_blogs.dart';
import 'package:internative_assignment/model/dataaccess/logout.dart';
import 'package:internative_assignment/view/home_page.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
  UserController _userController = Get.find();
  BlogController _blogController = Get.find();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => Container(
                height: 35,
                width: 35,
                child: Badge(
                    badgeContent:
                        Text(widget._userController.favBlogs.length.toString()),
                    child: Icon(
                      Icons.favorite,
                      size: 32,
                    )),
              )),
          IconButton(
              onPressed: () async {
                EasyLoading.show(status: 'Bloglar Yükleniyor');
                widget._blogController.blogs.clear();
                await getBlogs(null, 'all');
                EasyLoading.dismiss();
                Get.toNamed('/homepage');
              },
              icon: Icon(
                Icons.home,
                color: Colors.grey,
                size: 32,
              )),
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
            'My Favorites',
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
                                                        widget._blogController
                                                            .blogs
                                                            .clear();
                                                        await getBlogs(
                                                            null, 'fav');
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
                                                        widget._blogController
                                                            .blogs
                                                            .clear();
                                                        await getBlogs(
                                                            null, 'fav');
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
                                                            widget
                                                                ._blogController
                                                                .blogs
                                                                .clear();
                                                            await getBlogs(
                                                                null, 'fav');
                                                          },
                                                          icon: Icon(
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
                                                          )),
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
                                                            widget
                                                                ._blogController
                                                                .blogs
                                                                .clear();
                                                            await getBlogs(
                                                                null, 'fav');
                                                          },
                                                          icon: Icon(
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
                                                          )),
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
                                                            widget
                                                                ._blogController
                                                                .blogs
                                                                .clear();
                                                            await getBlogs(
                                                                null, 'fav');
                                                          },
                                                          icon: Icon(
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
                                                          )),
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
