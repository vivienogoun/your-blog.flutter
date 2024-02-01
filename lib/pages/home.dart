import 'package:flutter/material.dart';
import 'package:your_blog/screens/bookmarks.dart';
import 'package:your_blog/screens/home.dart';
import 'package:your_blog/screens/posts.dart';
import 'package:your_blog/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = [
    HomeScreen(),
    BookmarksScreen(),
    PostsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Favorites',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'My Posts'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),
        ],
      ), /*BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Home',
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  icon: const Icon(Icons.home),
                  iconSize: 30,
                  color: currentIndex == 0 ? Colors.black87 : Colors.black26,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  icon: const Icon(Icons.bookmark),
                  iconSize: 30,
                  color: currentIndex == 1 ? Colors.black87 : Colors.black26,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                  icon: const Icon(Icons.article),
                  iconSize: 30,
                  color: currentIndex == 2 ? Colors.black87 : Colors.black26,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                  icon: const Icon(Icons.person),
                  iconSize: 30,
                  color: currentIndex == 3 ? Colors.black87 : Colors.black26,
                ),
              ],
            ),
          )
        ),
      ),*/
      body: _pages.elementAt(_selectedIndex)
    );
  }
}