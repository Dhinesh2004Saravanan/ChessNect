import 'dart:convert';

import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:chess_application_1/modelClass/newsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';





class NewsPage extends StatefulWidget {


  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {


  late DateTime _startTime;
  late int _currentIndex;
  List<Article> newsFeed=[];
  int _selectedIndex=0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    processData();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
    _startTime = DateTime.now();

  }
  @override
  void dispose() {
    // Log time for the last page when the widget is disposed
    int durationInSeconds = DateTime.now().difference(_startTime).inSeconds;
    Likes.timeSpent(index: _currentIndex,durationInSeconds:  durationInSeconds);
    super.dispose();
  }





  Future<void> processData() async
  {
    final response=await rootBundle.loadString("assets/chessData.json");
    var jsonData=await json.decode(response);
    var value=NewsData.fromJson(jsonData);
    newsFeed=value.articles.sublist(0,11);
    print(newsFeed);
    setState(() {
      newsFeed;
    });
    print(newsFeed);

  }
  @override
  Widget build(BuildContext context) {
    double _width=MediaQuery.of(context).size.width;
    double _height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView.builder(

          onPageChanged: (index){

            int durationInSeconds = DateTime.now().difference(_startTime).inSeconds;
           Likes.timeSpent(index:  _currentIndex,durationInSeconds:  durationInSeconds);

            setState(() {
              _currentIndex = index;
              _startTime = DateTime.now();
            });
          },

          controller: _pageController,
          itemCount: newsFeed.length,
          itemBuilder: (context,index){

            return InkWell(

              onDoubleTap: (){

              },
              child: Container(
                width: _width,
                height: _height,

                child: Center(
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20)
                    ,child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         newsFeed[index].title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Image.network(
                          newsFeed[index].urlToImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16),

                        Text(
                          newsFeed[index].description! ,
                          style: TextStyle(fontSize: 16),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            );


          }),


      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(FontAwesomeIcons.home),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text('Profile'),
          ),
          FlashyTabBarItem(
            icon: Icon(FontAwesomeIcons.searchengin),
            title: Text('Search'),
          ),

        ],
      ),
    );
  }





}

