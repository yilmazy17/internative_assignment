import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internative_assignment/controller/blogs_controller.dart';
import 'package:internative_assignment/controller/user_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internative_assignment/model/dataaccess/getLocation.dart';
import 'package:internative_assignment/model/dataaccess/get_blogs.dart';
import 'package:internative_assignment/model/dataaccess/logout.dart';
import 'package:internative_assignment/view/materials/buttons.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  UserController _userController = Get.find();
  BlogController _blogController = Get.find();
}

class _ProfilePageState extends State<ProfilePage> {
  LatLng? _currentPostion;
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    _currentPostion = LatLng(position.latitude, position.longitude);
    setState(() {});
  }

  Completer<GoogleMapController> _mapController = Completer();
  String? longtitude;
  String? latitude;
  final Set<Marker> _markers = {};
  String? image;
  @override
  void initState() {
    _getUserLocation();
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
          Icon(
            Icons.person,
            size: 32,
          ),
        ],
      )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'My Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _currentPostion == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : SafeArea(
              child: Container(
                margin: EdgeInsets.all(13),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Container(
                            height: 174,
                            width: 174,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: (widget._userController.image == null)
                                    ? (Colors.grey)
                                    : (null),
                                image: (widget._userController.image == null)
                                    ? (null)
                                    : DecorationImage(
                                        image: NetworkImage(
                                          widget._userController.image
                                              .toString(),
                                        ),
                                      )),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          width: Get.width,
                          height: 174,
                          child: Theme(
                            data: ThemeData.dark(),
                            child: GoogleMap(
                              markers: _markers,
                              onTap: (LatLng a) {
                                _markers.clear();
                                _markers.add(Marker(
                                  markerId: MarkerId('Yeni Lokasyon'),
                                  infoWindow:
                                      InfoWindow(title: 'Yeni Lokasyon'),
                                  position: a,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed,
                                  ),
                                ));
                                setState(() {});
                                longtitude = a.longitude.toString();
                                latitude = a.latitude.toString();
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: _currentPostion!,
                                zoom: 14.4746,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _mapController.complete(controller);
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          height: 56,
                          child: LoginRegisterButton(
                              text_color: Colors.black,
                              background_color: Colors.white,
                              icon: Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              textValue: 'Save',
                              method: () async {
                                if (latitude != null || longtitude != null) {
                                  EasyLoading.show(status: 'Kaydediliyor');
                                  var result =
                                      await getLocation(longtitude, latitude);
                                  if (result!['status'] == true) {
                                    EasyLoading.showSuccess('Kayıt Başarılı',
                                        duration: Duration(seconds: 2),
                                        dismissOnTap: true);
                                    setState(() {});
                                  } else {
                                    EasyLoading.showError('Kayıt Başarısız',
                                        duration: Duration(seconds: 2),
                                        dismissOnTap: true);
                                  }
                                } else {
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.low);
                                  var result = await getLocation(
                                      position.longitude.toString(),
                                      position.latitude.toString());
                                  if (result!['status'] == true) {
                                    EasyLoading.showSuccess('Kayıt Başarılı',
                                        duration: Duration(seconds: 2),
                                        dismissOnTap: true);
                                    setState(() {});
                                  } else {
                                    EasyLoading.showError('Kayıt Başarısız',
                                        duration: Duration(seconds: 2),
                                        dismissOnTap: true);
                                  }
                                }
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          height: 56,
                          child: LoginRegisterButton(
                              text_color: Colors.white,
                              background_color: Colors.black,
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              textValue: 'LogOut',
                              method: () async {
                                EasyLoading.show(status: 'Oturum Kapatılıyor');
                                var result = await logout();
                                if (result == true) {
                                  EasyLoading.dismiss();
                                  Get.toNamed('/loginpage');
                                } else {
                                  EasyLoading.showError(
                                      'Beklenmeyen Bir Hata Oluştu',
                                      duration: Duration(seconds: 4),
                                      dismissOnTap: true);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
