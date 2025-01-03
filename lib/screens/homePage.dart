import 'dart:async';
import 'dart:convert';

import 'package:chess_application_1/Navigation/drawernavigation.dart';
import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:chess_application_1/modelClass/newsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NewsPageState extends State<NewsPage> {
  final PageController _bNewsController = PageController();
  Timer? _bnewsTimer;
  int _currentBnewsPage = 0;

  late DateTime _startTime;
  late int _currentIndex;
  List<Article> newsFeed = [];
  int _selectedIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    processData();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
    _startTime = DateTime.now();
  }

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

  @override
  void dispose() {
    // Log time for the last page when the widget is disposed
    int durationInSeconds = DateTime.now().difference(_startTime).inSeconds;
   // Likes.timeSpent(index: _currentIndex, durationInSeconds: durationInSeconds);
    _bnewsTimer?.cancel();
    _bNewsController.dispose();
    super.dispose();
  }

  Future<void> processData() async {
    final response = await rootBundle.loadString("assets/chessData.json");
    var jsonData = await json.decode(response);
    var value = NewsData.fromJson(jsonData);
    newsFeed = value.articles.sublist(0, 11);
    print(newsFeed);
    setState(() {
      newsFeed;
    });
    print(newsFeed);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return

      Scaffold(
        backgroundColor: TColors.NSwhite,
        key: _scaffoldKey,
        drawer: DrawerNav(),
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
          title: Text(
            'News',
            style: GoogleFonts.aBeeZee(fontSize: 20),
          ),
        ),
        body:
        // SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         _buildBreakingnewsSection(context, height, width),
        //         SizedBox(height: height * 0.012),
        //         _buildBreakingNews(),
        //         SizedBox(height: height * 0.021),
        //         _buildRecomendSection(context, height, width),
        //       ],
        //     ),
        //   ),
        // )
        PageView.builder(
            onPageChanged: (index) {
              int durationInSeconds =
                  DateTime.now().difference(_startTime).inSeconds;
              // Likes.timeSpent(
              //     index: _currentIndex, durationInSeconds: durationInSeconds);

              setState(() {
                _currentIndex = index;
                _startTime = DateTime.now();
              });
            },
            controller: _pageController,
            itemCount: newsFeed.length,
            itemBuilder: (context, index) {

              return NewsDetailPage(feeds: newsFeed[index],height: _height);
              // return Stack(
              //
              //   children: [
              //     //  * bottom
              //     Column(
              //       children: [
              //         Image.network(newsFeed[index].urlToImage!,height: _height/2.5,fit: BoxFit.fill,)
              //       ],
              //     )
              //
              //     // * top
              //
              //   ],
              // );
              //
               
            }),
        // bottomNavigationBar: FlashyTabBar(
        //   selectedIndex: _selectedIndex,
        //   showElevation: true,
        //   onItemSelected: (index) => setState(() {
        //     _selectedIndex = index;
        //   }),
        //   items: [
        //     FlashyTabBarItem(
        //       icon: Icon(FontAwesomeIcons.home),
        //       title: Text('Home'),
        //     ),
        //     FlashyTabBarItem(
        //       icon: Icon(FontAwesomeIcons.user),
        //       title: Text('Profile'),
        //     ),
        //     FlashyTabBarItem(
        //       icon: Icon(FontAwesomeIcons.searchengin),
        //       title: Text('Search'),
        //     ),
        //   ],
        // ),
        );
  }

  // Widget _buildBreakingnewsSection(BuildContext context, double height, double width) {
  //   return SizedBox(
  //     height: height * 0.05,
  //     width: width * 0.95,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Breaking News',
  //           style:
  //               GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Get.to(() => Offers());
  //           },
  //           child: Text(
  //             'View All',
  //             style:
  //                 GoogleFonts.aBeeZee(fontSize: 14, color: TColors.textlinks),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildBreakingNews() {
  //   return Container(
  //     height: 180,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     clipBehavior: Clip.hardEdge,
  //     child: PageView.builder(
  //       controller: _bNewsController,
  //       itemCount: newsFeed.length,
  //       itemBuilder: (context, index) {
  //         final offer = newsFeed[index];
  //         return GestureDetector(
  //           onTap: () {
  //             // Get.to(() => Offers());
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 9),
  //             child: Stack(
  //               children: [
  //                 // Image widget
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Image.network(
  //                     newsFeed[index].urlToImage!,
  //                     fit: BoxFit.fill,
  //                     width: double.infinity,
  //                   ),
  //                 ),
  //                 // Gradient overlay
  //                 Positioned.fill(
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         colors: [
  //                           Colors.transparent,
  //                           TColors.NSblack.withOpacity(0.9),
  //                         ],
  //                       ),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   left: 0,
  //                   right: 0,
  //                   child: Container(
  //                     padding: EdgeInsets.all(12),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           newsFeed[index].title,
  //                           style: TextStyle(
  //                             // fontFamily: TFont.primaryfontfamily,
  //                             color: TColors.textsecondary,
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                         SizedBox(height: 4),
  //                         Text(
  //                           newsFeed[index].description!,
  //                           style: TextStyle(
  //                             // fontFamily: TFont.secondaryfontfamily,
  //                             color: TColors.textsecondary,
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // Widget _buildRecomendSection(
  //     BuildContext context, double height, double width) {
  //   return SizedBox(
  //     height: height * 0.05,
  //     width: width * 0.95,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Recommendation',
  //           style:
  //               GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Get.to(() => Offers());
  //           },
  //           child: Text(
  //             'View All',
  //             style:
  //                 GoogleFonts.aBeeZee(fontSize: 14, color: TColors.textlinks),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


Widget NewsDetailPage({required Article feeds,required double height})
{
  return Stack(
    children: [
      // for background image

      Positioned.fill(child: Image.network(feeds.urlToImage!,fit: BoxFit.fill  ,height: height/2,)),


      SafeArea(child: Column(
        children: [
          SizedBox(height: 30,),

          Row(

            children: [
              Container(
                padding: EdgeInsets.only(left: 10,right: 5),

                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.5),

                  child: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white,),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(left: 10,right: 5),

                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.5),

                  child: Icon(FontAwesomeIcons.bookmark, color: Colors.white,),
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),

                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.5),

                  child: Icon(Icons.more_vert, color: Colors.white,),
                ),
              ),
            ],
          ),


          Spacer(),

          Padding(padding: EdgeInsets.only(left: 20,right: 20)
          ,child: Text(feeds.title,style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white
            ),),
          ),

          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            height: height/2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2
                )
              ],
              borderRadius: BorderRadius.only(

                topRight: Radius.circular(40),
                topLeft: Radius.circular(40)
              )
            ),

            child: SingleChildScrollView(child: Column(
              children: [

                Text(feeds.source.name,style:  GoogleFonts.aBeeZee(
                    fontSize: 18
                ),),
                SizedBox(height: 20,),

                Text(feeds.description!,style: GoogleFonts.aBeeZee(
                  fontSize: 18
                ),),
              ],
            )),

          )
        ],
      ))
      // Content


    ],
  );
}