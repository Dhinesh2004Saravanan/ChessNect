import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetails
{
  static FirebaseFirestore firestore=FirebaseFirestore.instance;
  
  static Future<void> saveLocation({required Position pos}) async
  {
    var userId=await FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection("USER PROFILE").doc(userId).update({
      "latitude":pos.latitude,
      "longtitude":pos.longitude
    }).then((n){
      print("n");
    });
  }
  
}