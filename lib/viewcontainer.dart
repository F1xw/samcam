import 'package:flutter/material.dart';

import 'views/live.view.dart';
import 'views/images.view.dart';
import 'views/weight.view.dart';

class ViewContainer extends StatefulWidget {
  ViewContainer({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ViewContainerState createState() => _ViewContainerState();
}

class _ViewContainerState extends State<ViewContainer> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    WeightList(),
    ImagesList(),
    LiveView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.square_foot),
            label: 'Gewichtslog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Fotos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live',
          ),
        ],
      ),
    );
  }
}
