import 'dart:convert';

import 'package:chess_application_1/backendOperations/locationDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController
{
  Future<void> getCurrentLocation() async
  {
    bool isServiceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!isServiceEnabled)
      {
        print("location services are not enabled");
      }
    await Geolocator.requestPermission();
    LocationPermission permission=await Geolocator.checkPermission();

    if(permission==LocationPermission.denied)
      {
        await Geolocator.requestPermission();
      }
    else if(permission==LocationPermission.always)
      {
        print("LOCATION GIVEN");
      }

  Position position=  await Geolocator.getCurrentPosition();
    print("pos ${position.longitude},${position.latitude}");
    update();
    LocationDetails.saveLocation(pos: position);

  }

  @override
  void onInit() {
    print("LOCATION CALL");



  }

  @override
  void onClose() {

  }

  @override
  void onReady() {

  }
}