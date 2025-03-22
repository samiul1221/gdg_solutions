import 'package:flutter/material.dart';
import 'package:gdg_solution/farmer/farmer_awareness.dart';
import 'package:gdg_solution/farmer/home_page.dart';
import 'package:gdg_solution/farmer/listing_page.dart';
import 'package:gdg_solution/farmer/schemes.dart';
import 'package:gdg_solution/farmer/weather.dart';

// Create a global key to access the navigation state from anywhere
final GlobalKey<_MainNavigationState> mainNavigationKey =
    GlobalKey<_MainNavigationState>();

class MainNavigation extends StatefulWidget {
  final int selectedIndex;
  MainNavigation({this.selectedIndex = 0}) : super(key: mainNavigationKey);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int selectedIndex;

  // List of pages corresponding to your routes
  final List<Widget> _pages = [
    HomePage(),
    ListingPage(),
    Schemes(),
    FarmerAwareness(),
    Weather(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the selected index from the widget parameter
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the selected index if it changes from outside
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        selectedIndex = widget.selectedIndex;
      });
    }
  }

  // Public method to update the selected index
  void updateIndex(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Important for 5 items
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Use your app's theme color
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Listing'),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Awareness',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
        ],
      ),
    );
  }
}

// Helper class to navigate from anywhere in your app
class NavigationHelper {
  // Use this in your GestureDetector onTap
  static void navigateToTab(int index, BuildContext context) {
    // First update the bottom navigation bar index
    mainNavigationKey.currentState?.updateIndex(index);

    // Navigate back to the main navigation if needed
    // This ensures the bottom navigation bar is visible
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
