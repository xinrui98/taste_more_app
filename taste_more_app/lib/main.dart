import 'dart:io';
import 'package:flutter/material.dart';
import 'all_data_screen.dart';
import 'learn_screen.dart';
import 'main_screen.dart';

void main() => runApp(Home());
ThemeData _baseTheme = ThemeData(
  fontFamily: "Roboto",
  canvasColor: Colors.transparent,
);


class Home extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {


    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  int selectedIndex = 0;
  MainScreen mainScreen;
  AllDataScreen allDataScreen;
  LearnScreen learnScreen;
  List pages;
  final PageStorageBucket bucket = PageStorageBucket();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainScreen = MainScreen();
    learnScreen = LearnScreen();

    pages = [mainScreen,learnScreen];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _baseTheme,
      debugShowCheckedModeBanner: false,
      home: (Platform.isIOS) ? SafeArea(
        child: Scaffold(
          body: Stack(children: <Widget>[PageStorage(bucket: bucket, child: pages[selectedIndex]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    primaryColor: Colors.red,
                    textTheme: Theme.of(context)
                        .textTheme
                        .copyWith(caption: TextStyle(color: Colors.white70))),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), title: Text("Home")),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.spa), title: Text("Learn")),
                  ],
                  currentIndex: selectedIndex,
                  fixedColor: Colors.white,
                  onTap: _onItemTapped,
                ),
              ),
            ),
          ]),
        ),
      ) : Scaffold(
        body: Stack(children: <Widget>[pages[selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  primaryColor: Colors.red,
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: TextStyle(color: Colors.white70))),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), title: Text("Home")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.spa), title: Text("Learn")),
                ],
                currentIndex: selectedIndex,
                fixedColor: Colors.white,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
