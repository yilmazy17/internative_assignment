import 'package:get/get.dart';

class UserController extends GetxController {
  String? userMail;
  String? bearerToken;
  String? userID;
  addUserId(String? id) {
    userID = id;
  }

  Map<String, dynamic>? location;
  addLocation(Map<String, dynamic>? currrentLocation) {
    location = currrentLocation;
  }

  String? image;
  addImage(String? profileImage) {
    image = profileImage;
  }

  var favBlogs = [].obs;

  addFavBlog(Map<String, dynamic>? favBlog) {
    favBlogs.add(favBlog);
  }

  UserController(this.userMail, this.bearerToken);
}
