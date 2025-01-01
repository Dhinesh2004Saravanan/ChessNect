
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Likes
{
  static final  FirebaseFirestore firestore=FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  static List<String> likedPeople=[];
  static var data={};

 static Future<void> addLikes({required int index,required BuildContext context}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("NEWSFEED")
          .doc("$index")
          .get();

      if (snapshot.exists) {
        // Extract the "likes" field and cast it as a list
        var data = snapshot.data() as Map<String, dynamic>; // Explicitly cast to a Map
        likedPeople = List<String>.from(data["likes"] ?? []);
        print("Liked People: $likedPeople");
      } else {
        print("Document does not exist.");
        likedPeople = []; // Initialize with an empty list if the document doesn't exist
      }


      var userId=await firebaseAuth.currentUser!.uid.toString();
      if(!likedPeople.contains(userId))
        {
          likedPeople.add(userId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("LIKED SUCCESSFULLY"))
          );


        }
      else
        {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(" POST WAS ALREADY LIKED "))
          );
          return;
        }



      await firestore.collection("NEWSFEED").doc("$index").update({
        "likes":likedPeople
      }).then((val){
        print("updated successfully");
      });
    } catch (e) {
      print("Error fetching likes: $e");
    }
  }




 static Future<void> timeSpent({required int index,required int durationInSeconds}) async
 {
    // add database logic for storing the time in firebase

   DocumentSnapshot snapshot = await FirebaseFirestore.instance
       .collection("NEWSFEED")
       .doc("$index")
       .get();

   if(snapshot.exists)
     {
       var data = snapshot.data() as Map<String, dynamic>;
       var userId=await firebaseAuth.currentUser!.uid.toString();
       print("duration is $durationInSeconds");

       Map<String,dynamic> oldData=data["seenDuration"];


      print("val is ${oldData[userId]}");

      if(oldData[userId]==null)
        {
          print(true);
          oldData[userId]=durationInSeconds;
          print(oldData);
        }
      else
        {
          print("false");
          oldData[userId]+=durationInSeconds;
          print(oldData);
        }




           await firestore.collection("NEWSFEED").doc("$index").update({
             "seenDuration":oldData
           });


     }
 }



}