import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'AddPolicy.dart';
import 'HomePage.dart';
import 'PolicySearch.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   runApp(MaterialApp(
//     home: BottomNavBar(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key, this.title, this.uid}) : super(key: key);
  //update the constructor to include the uid
  final String title;
  final String uid;
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Widget _child = HomePage();

  @override
  void initState() {
    super.initState();
    _child = HomePage();
  }

  //int _page = 0;
  //final _pageOption = [PolicySearching(), HomePage(), AddingPolicy()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        body: _child,
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.white,
          backgroundColor: Colors.deepOrange,
          buttonBackgroundColor: Colors.white,
          height: 60,
          items: [
            Icon(Icons.search, size: 40, color: Colors.black),
            Icon(Icons.car_repair, size: 40, color: Colors.black),
            Icon(Icons.add, size: 40, color: Colors.black),
          ],
          animationDuration: Duration(milliseconds: 200),
          animationCurve: Curves.bounceInOut,
          index: 1,
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _child = PolicySearching();
                  break;
                case 1:
                  _child = HomePage();
                  break;
                case 2:
                  _child = AddingPolicy();
                  break;
              }
            });
          },
        ),
      ),
    );
  }
}
