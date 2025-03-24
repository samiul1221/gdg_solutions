import 'package:flutter/material.dart';
import 'package:gdg_solution/farmer/farmer_awareness.dart';
import 'package:gdg_solution/farmer/listing_page.dart';
import 'package:gdg_solution/farmer/mainNav.dart';
import 'package:gdg_solution/farmer/weather.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String role;

  HomePage({required this.username, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? _selected_Lang = "English";
  final List<String> Lang_Support = ["English", "Hindi"];

  late AnimationController _my_LottieAnimationController;
  late String username;
  late String role;

  @override
  void initState() {
    username = widget.username;
    role = widget.role;
    super.initState();
    _my_LottieAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  final List<String> lottie_icon = [
    'lib/assets/animation_json/Listing.json',
    'lib/assets/animation_json/govt.json',
    'lib/assets/animation_json/human_leaf.json',
    'lib/assets/animation_json/weather.json',
  ];

  final List<String> tileName = [
    'Listings',
    'Government Schemes',
    'Farmer Awareness',
    'Weather',
  ];

  final List<String> pages = [
    '/listing_page',
    '/Scheme_page',
    '/farmer_awareness_page',
    '/weather_page',
  ];
  
  late final List<Widget> _pages;

  @override
  void initState() {
    username =
  void voice_assistant() {
    print("clicked");
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Get screen size to make layout responsive
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use Expanded to prevent overflow in username
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(fontSize: 30),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: _selected_Lang,
                borderRadius: BorderRadius.circular(15),
                underline: Container(),
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                items:
                    Lang_Support.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(child: Text(value), value: value);
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selected_Lang = newValue!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.person, size: 30),
              ),
            ],
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40), // Reduced height to give more space for grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0, // Make cells square
                  crossAxisSpacing: 10, // Add spacing between columns
                  mainAxisSpacing: 10, // Add spacing between rows
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      NavigationHelper.navigateToTab(index + 1, context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: colors.onSurface.withAlpha(30),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Use Expanded for Lottie to take available space
                          Expanded(
                            flex: 3, // 75% of space for animation
                            child: Lottie.asset(
                              lottie_icon[index],
                              fit: BoxFit.contain, // Ensure animation fits
                            ),
                          ),
                          SizedBox(height: 4),
                          // Use Expanded for text to take remaining space
                          Expanded(
                            flex: 1, // 25% of space for text
                            child: Center(
                              child: Text(
                                tileName[index],
                                style: TextStyle(
                                  fontSize: 16, // Slightly smaller font
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines:
                                    2, // Allow up to 2 lines for longer text
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: voice_assistant,
          backgroundColor: colors.tertiary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.keyboard_voice_sharp, size: 40),
        ),
      ),
    );
  }
}
