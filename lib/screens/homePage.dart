
import 'dart:convert';

import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:chess_application_1/controllers/newsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Navigation/drawernavigation.dart';

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NewsPageState extends State<NewsPage> {
  late DateTime _startTime;
  late int _currentIndex;
  List<Map<String, dynamic>> newsFeed = [];
  int _selectedIndex = 0;
  late PageController _pageController;


  String formatPublishedDate(DateTime publishedDate) {

    final DateTime currentDate = DateTime.now();

    final Duration difference = currentDate.difference(publishedDate);

    if (difference.inHours < 7) {
      return '${difference.inHours}h'; // Show time inwh hours if within 7 hours
    } else if (difference.inHours > 12) {
      // If the difference is more than 12 hours, show the date
      return DateFormat("d MMM, yy HH:mm").format(publishedDate);
    } else {
      return '${difference.inHours}h ago';
    }
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
    _startTime = DateTime.now();


    setState(() {
      print("set calleddddddddddddddd");

    });
  }
  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    NewsController newsController=Get.put(NewsController());

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: DrawerNav(),


      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
      ),
      body:
      Obx((){
        if(newsController.newsItems.value.isEmpty)
        {
          return SizedBox();
        }



        return PageView.builder(

            controller: _pageController,
            onPageChanged: (index){

              Get.find<NewsController>().getLikedAndDisLikedCount(index: index+1);
              print("BEFORE CURRENT INDEX ${_currentIndex}");


              int durationInSeconds = DateTime.now().difference(_startTime).inSeconds;
              _currentIndex = index;
              _startTime = DateTime.now();
              Likes.timeSpent(index: index, durationInSeconds: durationInSeconds);
              print("AFTER CURRENT INDEX ${_currentIndex}");
              print("AFTER DURATION $durationInSeconds");

            },
            itemCount: newsController.newsItems.value.length,
            itemBuilder: (context,index) {

              final newsData=newsController.newsItems.value[index];
              return NewsDetailPage(height: _height,
                  title: newsData.title??"",
                  description: newsData.contentText??"",
                  imageUrl: newsData.image??"",
                  publishedDate: formatPublishedDate(newsData.datePublished??DateTime.now()),
                  authorName: formatAuthorName(newsData.authors[0].name!) ??"",
                  authorImage: newsData.attachments[0].url??" ",
                  index: index, context: context,
                  likedCount: newsController.likedAndDisLikedCount[0],
                  dislikedCount: newsController.likedAndDisLikedCount[1]


              );
            }
        );


      })



    );
  }
}

String formatAuthorName(String authorName) {
  final urlPattern =
      r"^(https?:\/\/)?(www\.)?([a-zA-Z0-9_-]+)\.(com|org|net|co|gov)\/([a-zA-Z0-9_-]+)$";
  final regExp = RegExp(urlPattern);

  if (regExp.hasMatch(authorName)) {
    final uri = Uri.parse(authorName);
    final host = uri.host;
    String platform = '';
    if (host.contains('facebook')) {
      platform = 'Facebook';
    } else if (host.contains('twitter')) {
      platform = 'Twitter';
    } else if (host.contains('instagram')) {
      platform = 'Instagram';
    } else if (host.contains('linkedin')) {
      platform = 'LinkedIn';
    } else if (host.contains('youtube')) {
      platform = 'YouTube';
    } else {
      platform = host.split('.').first.capitalize.toString();
    }
    final username = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    return '$username ($platform)';
  }
  return authorName;
}


Widget NewsDetailPage({
  required double height,
  required String title,
  required String description,
  required String imageUrl,
  required String publishedDate,
  required String authorName,
  required String authorImage,
  required int index,
  required BuildContext context,
  required int likedCount,
  required int dislikedCount
}) {
  final formattedAuthorName = formatAuthorName(authorName);



  bool likedStatus=false;
  bool dislikedStatus=false;
  bool bookMarked=false;
  return Stack(
    children: [
      Positioned.fill(
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.fill,
              height: height / 3,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                title,
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Trending • $publishedDate",
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              height: height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(authorImage),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          formattedAuthorName,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Spacer(),
                      IconButton(onPressed: (){

                        if(FirebaseAuth.instance.currentUser==null)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PLEASE LOGIN TO USE THIS FUNCTIONALITY")));
                          }
                        else
                          {
                            savedNews(newsTitle: title,description: description,imageUrl: imageUrl).whenComplete((){

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text("SUCCESSFULLY SAVED")));

                            });
                          }


                      }, icon: Icon(Icons.bookmark))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            size: 18,

                          ),
                          onPressed:
                          (FirebaseAuth.instance.currentUser==null)?(){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text("PLEASE LOGIN TO USE THIS FUNCTIONALITY")));
                          }:

                              () async {
                          await  Likes.addLikes(index: index, context: context).whenComplete((){
                            Get.find<NewsController>().getLikedAndDisLikedCount(index: index);
                          });

                          },
                        ),
                      GetBuilder<NewsController>(builder: (_){
                       return  Text(
                        _.likedAndDisLikedCount[0].toString(),
                          style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        );
                      }),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            size: 18,

                          ),
                          onPressed:

                          (FirebaseAuth.instance.currentUser==null)?(){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text("PLEASE LOGIN TO USE THIS FUNCTIONALITY")));
                          }:

                              () {
                            Likes.addDisLikes(index: index, context: context).whenComplete((){
                              Get.find<NewsController>().getLikedAndDisLikedCount(index: index);

                            });
                          },
                        ),
                        GetBuilder<NewsController>(builder: (_){
                          return  Text(
                           Get.find<NewsController>().likedAndDisLikedCount[1].toString(),
                            style: GoogleFonts.aBeeZee(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TColors.primary,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: GoogleFonts.aBeeZee(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



// saved the news


Future<void> savedNews({required String newsTitle,required String description,required String imageUrl}) async
{
  SharedPreferences preferences=await SharedPreferences.getInstance();

   var counter=await preferences.getInt('counter')??0;


   await preferences.setStringList(counter.toString(), [newsTitle,description,imageUrl]);
   counter++;

   print(counter);
   await preferences.setInt('counter', counter);




}





/*
import 'dart:async';
import 'dart:convert';

import 'package:chess_application_1/Navigation/drawernavigation.dart';
import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:chess_application_1/modelClass/newsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ShowDetailsController.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key);

  final NewsController controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerNav(),
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text('News', style: GoogleFonts.aBeeZee(fontSize: 20)),
      ),
      body: Obx(() {
        if (controller.newsFeed.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.updateCurrentPage,
          itemCount: controller.newsFeed.length,
          itemBuilder: (context, index) {
            final article = controller.newsFeed[index];
            final isBookmarked = controller.bookmarkStatus[index] ?? false;
            return NewsDetailPage(
              context: context,
              index: index,
              feeds: article,
              isBookmarked: isBookmarked,
              onBookmarkToggle: () => controller.toggleBookmark(index),
              height: MediaQuery.of(context).size.height,
            );
          },
        );
      }),
    );
  }
}

Widget NewsDetailPage({
  required BuildContext context,
  required Article feeds,
  required double height,
  required bool isBookmarked,
  required VoidCallback onBookmarkToggle,
  required int index
}) {
  return Stack(
    children: [

      Positioned.fill(
        child: Stack(
          children: [
            Image.network(
              feeds.urlToImage!,
              fit: BoxFit.fill,
              height: height / 2,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                feeds.title,
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Trending • 6 hours ago",
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              height: height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.icon-icons.com/icons2/70/PNG/512/bbc_news_14062.png"),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              feeds.source.name,
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: (FirebaseAuth.instance.currentUser!=null)? onBookmarkToggle:(){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PLEASE LOGIN TO ACCESS THIS FEATURE"))
                          );
                        },
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? TColors.iconlink
                              : TColors.iconprimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 145,
                    // decoration: BoxDecoration(
                    //     color: Colors.black26,
                    //     borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            // Like Button
                            IconButton(
                              onPressed: () {
                                Likes.addLikes(index: index, context: context);
                              },
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: TColors.iconlink,
                                size: 18,
                              ),
                            ),
                            Text(
                              '1',
                              style: GoogleFonts.aBeeZee(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Dislike Button
                            IconButton(
                              onPressed: () {
                                Likes.addDisLikes(index: index, context: context);
                              },
                              icon: Icon(
                                Icons.thumb_down_alt_outlined,
                                color: TColors.iconlink,
                                size: 18,
                              ),
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.aBeeZee(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        feeds.description!,
                        style: GoogleFonts.aBeeZee(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

 */


/*
  void _startBreakingnewsAutoScroll() {
    _bnewsTimer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_bNewsController.hasClients) {
        _currentBnewsPage++;
        if (_currentBnewsPage >= newsFeed.length) {
          _currentBnewsPage = 0;
        }
        _bNewsController.animateToPage(
          _currentBnewsPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
 */




/*
! * Final\



import 'dart:convert';

import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Navigation/drawernavigation.dart';

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NewsPageState extends State<NewsPage> {
  late DateTime _startTime;
  late int _currentIndex;
  List<Map<String, dynamic>> newsFeed = [];
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
    _startTime = DateTime.now();
   // fetchNewsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetch the news data from the API
  // Future<void> fetchNewsData() async {
  //   final response = await http.get(
  //     Uri.parse('https://rss.app/feeds/v1.1/t8KM2nAljlnxP5hn.json'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     setState(() {
  //       newsFeed = List<Map<String, dynamic>>.from(
  //           data['items']); // Update the newsFeed
  //     });
  //
  //     for(int i=0;i<10;i++)
  //       {
  //         await FirebaseFirestore.instance.collection("NEWSFEED").doc("$i").update({
  //           "title": newsFeed[i]['title'] ?? '',
  //           "description": newsFeed[i]['content_text'] ?? '',
  //           "imageUrl": newsFeed[i]['image'] ?? '',
  //         });
  //
  //       }
  //   }
  //   else {
  //     throw Exception('Failed to load data: ${response.statusCode}');
  //   }
  // }
  //
  // // Function to format publishedDate based on the time difference
  // String formatPublishedDate(String publishedDate) {
  //   final DateTime parsedDate = DateTime.parse(publishedDate);
  //   final DateTime currentDate = DateTime.now();
  //
  //   final Duration difference = currentDate.difference(parsedDate);
  //
  //   if (difference.inHours < 7) {
  //     return '${difference.inHours}h'; // Show time in hours if within 7 hours
  //   } else if (difference.inHours > 12) {
  //     // If the difference is more than 12 hours, show the date
  //     return DateFormat("d MMM, yy HH:mm").format(parsedDate);
  //   } else {
  //     return '${difference.inHours}h ago';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: DrawerNav(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
      ),
      body: newsFeed.isEmpty
          ? Center(
        child: Image.asset(
          'assets/images/Gifs/research.gif',
          height: 100,
          width: 100,
        ),
      )
          : PageView.builder(
        onPageChanged: (index) {
          int durationInSeconds = DateTime.now().difference(_startTime).inSeconds;
          Likes.timeSpent(index:  _currentIndex,durationInSeconds:  durationInSeconds);

          setState(() {
            _currentIndex = index;
            _startTime = DateTime.now();
          });
        },
        controller: _pageController,
        itemCount: newsFeed.length,
        itemBuilder: (context, index) {
          final newsItem = newsFeed[index];
    //      final publishedDate = formatPublishedDate(newsItem['date_published']);
          final authors = newsItem['authors'] as List<dynamic>;
          final authorName =
          authors.isNotEmpty ? authors[0]['name'] : 'Unknown Author';
          final authorImage = newsItem['attachments'].isNotEmpty
              ? newsItem['attachments'][0]['url']
              : 'https://via.placeholder.com/50';

          return NewsDetailPage(
            index: index,
            context: context,
            height: _height,
            title: newsItem['title'] ?? '',
            description: newsItem['content_text'] ?? '',
            imageUrl: newsItem['image'] ?? '',
            publishedDate: publishedDate,
            authorName: authorName,
            authorImage: authorImage,
          );
        },
      ),
    );
  }
}

String formatAuthorName(String authorName) {
  final urlPattern =
      r"^(https?:\/\/)?(www\.)?([a-zA-Z0-9_-]+)\.(com|org|net|co|gov)\/([a-zA-Z0-9_-]+)$";
  final regExp = RegExp(urlPattern);

  if (regExp.hasMatch(authorName)) {
    final uri = Uri.parse(authorName);
    final host = uri.host;
    String platform = '';
    if (host.contains('facebook')) {
      platform = 'Facebook';
    } else if (host.contains('twitter')) {
      platform = 'Twitter';
    } else if (host.contains('instagram')) {
      platform = 'Instagram';
    } else if (host.contains('linkedin')) {
      platform = 'LinkedIn';
    } else if (host.contains('youtube')) {
      platform = 'YouTube';
    } else {
      platform = host.split('.').first.capitalize();
    }
    final username = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    return '$username ($platform)';
  }
  return authorName;
}

extension StringCapitalizeExtension on String {
  String capitalize() {
    if (this == null || this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}

Widget NewsDetailPage({
  required double height,
  required String title,
  required String description,
  required String imageUrl,
  required String publishedDate,
  required String authorName,
  required String authorImage,
  required int index,
  required BuildContext context
}) {
  final formattedAuthorName = formatAuthorName(authorName);



  bool likedStatus=false;
  bool dislikedStatus=false;
  bool bookMarked=false;
  return Stack(
    children: [
      Positioned.fill(
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.fill,
              height: height / 3,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                title,
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Trending • $publishedDate",
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              height: height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(authorImage),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          formattedAuthorName,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Spacer(),
                      IconButton(onPressed: (){

                        if(FirebaseAuth.instance.currentUser==null)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PLEASE LOGIN TO USE THIS FUNCTIONALITY")));
                          }
                        else
                          {
                            savedNews(newsTitle: title,description: description,imageUrl: imageUrl);
                          }


                      }, icon: Icon(Icons.bookmark))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            size: 18,

                          ),
                          onPressed: () {
                            Likes.addLikes(index: index, context: context);
                          },
                        ),
                        Text(
                          '1',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            size: 18,

                          ),
                          onPressed: () {
                            Likes.addDisLikes(index: index, context: context);
                          },
                        ),
                        Text(
                          '0',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: GoogleFonts.aBeeZee(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



// saved the news


Future<void> savedNews({required String newsTitle,required String description,required String imageUrl}) async
{
  SharedPreferences preferences=await SharedPreferences.getInstance();

   var counter=await preferences.getInt('counter')??0;


   await preferences.setStringList(counter.toString(), [newsTitle,description,imageUrl]);
   counter++;

   print(counter);
   await preferences.setInt('counter', counter);




}





/*
import 'dart:async';
import 'dart:convert';

import 'package:chess_application_1/Navigation/drawernavigation.dart';
import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:chess_application_1/modelClass/newsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ShowDetailsController.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key);

  final NewsController controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerNav(),
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text('News', style: GoogleFonts.aBeeZee(fontSize: 20)),
      ),
      body: Obx(() {
        if (controller.newsFeed.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.updateCurrentPage,
          itemCount: controller.newsFeed.length,
          itemBuilder: (context, index) {
            final article = controller.newsFeed[index];
            final isBookmarked = controller.bookmarkStatus[index] ?? false;
            return NewsDetailPage(
              context: context,
              index: index,
              feeds: article,
              isBookmarked: isBookmarked,
              onBookmarkToggle: () => controller.toggleBookmark(index),
              height: MediaQuery.of(context).size.height,
            );
          },
        );
      }),
    );
  }
}

Widget NewsDetailPage({
  required BuildContext context,
  required Article feeds,
  required double height,
  required bool isBookmarked,
  required VoidCallback onBookmarkToggle,
  required int index
}) {
  return Stack(
    children: [

      Positioned.fill(
        child: Stack(
          children: [
            Image.network(
              feeds.urlToImage!,
              fit: BoxFit.fill,
              height: height / 2,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                feeds.title,
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Trending • 6 hours ago",
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              height: height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.icon-icons.com/icons2/70/PNG/512/bbc_news_14062.png"),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              feeds.source.name,
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: (FirebaseAuth.instance.currentUser!=null)? onBookmarkToggle:(){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PLEASE LOGIN TO ACCESS THIS FEATURE"))
                          );
                        },
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? TColors.iconlink
                              : TColors.iconprimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 145,
                    // decoration: BoxDecoration(
                    //     color: Colors.black26,
                    //     borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            // Like Button
                            IconButton(
                              onPressed: () {
                                Likes.addLikes(index: index, context: context);
                              },
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: TColors.iconlink,
                                size: 18,
                              ),
                            ),
                            Text(
                              '1',
                              style: GoogleFonts.aBeeZee(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Dislike Button
                            IconButton(
                              onPressed: () {
                                Likes.addDisLikes(index: index, context: context);
                              },
                              icon: Icon(
                                Icons.thumb_down_alt_outlined,
                                color: TColors.iconlink,
                                size: 18,
                              ),
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.aBeeZee(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        feeds.description!,
                        style: GoogleFonts.aBeeZee(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

 */


/*
  void _startBreakingnewsAutoScroll() {
    _bnewsTimer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_bNewsController.hasClients) {
        _currentBnewsPage++;
        if (_currentBnewsPage >= newsFeed.length) {
          _currentBnewsPage = 0;
        }
        _bNewsController.animateToPage(
          _currentBnewsPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
 */
 */