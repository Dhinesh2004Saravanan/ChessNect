import 'dart:async';
import 'dart:convert';

import 'package:chess_application_1/Navigation/drawernavigation.dart';
import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/modelClass/newsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _NewsPageState extends State<NewsPage> {
  final PageController _bNewsController = PageController();
  Map<int, bool> bookmarkStatus = {};
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

  void toggleBookmark(int index) {
    setState(() {
      bookmarkStatus[index] = !(bookmarkStatus[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
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
      body: PageView.builder(
        onPageChanged: (index) {
          int durationInSeconds =
              DateTime.now().difference(_startTime).inSeconds;
          setState(() {
            _currentIndex = index;
            _startTime = DateTime.now();
          });
        },
        controller: _pageController,
        itemCount: newsFeed.length,
        itemBuilder: (context, index) {
          return NewsDetailPage(
            feeds: newsFeed[index],
            height: _height,
            isBookmarked: bookmarkStatus[index] ?? false,
            onBookmarkToggle: () => toggleBookmark(index),
          );
        },
      ),
    );
  }
}

Widget NewsDetailPage({
  required Article feeds,
  required double height,
  required bool isBookmarked,
  required VoidCallback onBookmarkToggle,
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
                        onPressed: onBookmarkToggle,
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
                              onPressed: () {},
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
                              onPressed: () {},
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
