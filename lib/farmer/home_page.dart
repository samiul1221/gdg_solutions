import 'package:flutter/material.dart';
import 'package:gdg_solution/farmer/farmer_awareness.dart';
import 'package:gdg_solution/farmer/listing_page.dart';
import 'package:gdg_solution/farmer/mainNav.dart';
import 'package:gdg_solution/farmer/schemes.dart';
import 'package:gdg_solution/farmer/weather.dart';
import 'package:lottie/lottie.dart';
import 'package:gdg_solution/utils/crop_data_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? _selected_Lang = "English";
  // final globalData = GlobalData();
  // GlobalData.myVariable;

  // glo_var.selected_Lang
  // glo_var.GlobalData
  final List<String> Lang_Support = ["English", "Hindi"];

  late AnimationController _my_LottieAnimationController;
  @override
  void initState() {
    // TODO: implement initState
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

  // for bottom Nav bar
  // int _selectedIndex = 0;

  final List<Widget> _pages = [
    ListingPage(),
    Schemes(),
    FarmerAwareness(),
    Weather(),
  ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  void voice_assistant() {
    print("clicked");
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome!", style: TextStyle(fontSize: 30)),
                  Text("John Doe", style: TextStyle(fontSize: 16)),
                ],
              ),
              DropdownButton<String>(
                value: _selected_Lang,
                borderRadius: BorderRadius.circular(15),
                // elevation: 15,x
                // hint: Text("Select"),
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
        // leading: Container(color: Colors.amber),
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 80),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    NavigationHelper.navigateToTab(index + 1, context);

                    // MainNavigation(selectedIndex: 2);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: colors.onSurface.withAlpha(30),
                          // color: Colors.,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),

                    // width: double.infinity,
                    // Add this to allow the container to expand vertically
                    // constraints: BoxConstraints(minHeight: 100),
                    child: Column(
                      children: [
                        Container(
                          // Add height constraint or use Expanded for the Lottie animation
                          height: 120, // Adjust this value based on your needs
                          child: Lottie.asset(lottie_icon[index]),
                        ),
                        // Add some spacing between animation and text
                        SizedBox(height: 8),
                        // Uncomment this to show your text
                        Text(
                          tileName[index],
                          style: TextStyle(fontSize: 20),
                          // Add text overflow handling
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 4,
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
