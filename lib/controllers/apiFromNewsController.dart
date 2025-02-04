
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/api-credentials.dart';

class NewsFeedFromApi extends GetxController
{
  static String baseUrl = "http://staging.bdsd.technology/tts-app/api";
  
  
  List<dynamic> Result=[];
  Map<String,String> likedCount={};
  Map<String,String> dislikedCount={};
  
  Future<void> getNewsDetails() async
  {
     var response=await http.get(Uri.parse("$baseUrl"+"/news/list"),
       headers: {
         'Content-Type': 'application/json',
         'Username': TApicredentials.Username,
         'Password': TApicredentials.Password,
       },
     );
     var newsSet=jsonDecode(response.body);

      Result=newsSet["Result"];
      print(Result);
      update();

  }


  Future<void> setLike({required String id}) async
  {

       final Map<String,dynamic> body={
         "id": id,
         "type": 1
       };
       print(body);
       SharedPreferences preferences=await SharedPreferences.getInstance();
       String customerId=await preferences.getString("cid")??" ";
       print("CUSTOMER ID FOR IS ${customerId}");


       var response=await http.post(Uri.parse("$baseUrl"+"/news/reaction"),headers:
       {
         'Content-Type':'application/json',
         'Username':TApicredentials.Username,
         'Password':TApicredentials.Password,
         'customerid':customerId

       },

         body: jsonEncode(body)
       );


       var result=jsonDecode(response.body);

      var message=result["StatusCode"];
      print(result);
      if(message==0)
        {

          print("Success Message Resolved");
         await updateLikeCount(id: id);

        }




  }

   Future<void> updateLikeCount({required String id}) async
  {
    var response=await http.get(Uri.parse("$baseUrl"+"/news/detail/"+"$id"),
      headers: {
        'Content-Type':'application/json',
        'Username':TApicredentials.Username,
        'Password':TApicredentials.Password

      }


    );


    var result=jsonDecode(response.body);

    print(result);
    likedCount[id]=(result["Result"]["total_like"]).toString();
    print(result);
    dislikedCount[id]=(result["Result"]["total_dislike"]).toString();
    print("Liked Count is ${likedCount}");
    print("Disliked Count is ${dislikedCount}");
    update();

  }





  @override
  void onInit() {
    print("Called News Initially");
    getNewsDetails();
    
  }

  @override
  void onClose() {
    
  }

  @override
  void onReady() {
    
  }
}