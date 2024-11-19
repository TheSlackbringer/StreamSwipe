import 'package:flutter/material.dart';
import 'package:stream_swipe/presentation/widgets/user_page.dart';
import 'home_page.dart';
import 'stream_swipe_page.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const MyHomePage(title: 'Binge Buddy'),
    const StreamSwipePage(),
    const UserSetupPage()
  ];


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.movie)),
            label: 'StreamSwipe',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'User',
          ),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }
}
