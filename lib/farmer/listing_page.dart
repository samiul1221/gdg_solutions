import 'package:flutter/material.dart';
import 'package:gdg_solution/utils/listing_list_tiles.dart';
import 'package:gdg_solution/utils/crop_data_class.dart';

class ListingPage extends StatefulWidget {
  ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  List<CropData> cropList = [
    CropData(
      isOffered: false,
      govt_value: 12,
      quantity: 15,
      imagePath: 'lib/assets/crops/grain_crop1.png', // Path to your crop image
      cropName: 'Grain',
      date: '21st Jan 2025',
      yoursValue: 25.0,
      offeredValue: 24.0,
    ),
    CropData(
      isOffered: true,
      govt_value: 12,
      quantity: 15,
      imagePath: 'lib/assets/crops/rice_crop2.png', // Path to your crop image
      cropName: 'Rice',
      date: '31st Jan 2025',
      yoursValue: 25.0,
      offeredValue: 24.0,
    ),
    CropData(
      isOffered: false,
      govt_value: 12,
      quantity: 15,
      imagePath: 'lib/assets/crops/tea_crop3.jpg', // Path to your crop image
      cropName: 'Tea',
      date: '1st Feb 2025',
      yoursValue: 25.0,
      offeredValue: 24.0,
    ),

    // Add more CropData items as needed
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
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
                  Text("Your Listings", style: TextStyle(fontSize: 27)),
                  Text("John Doe", style: TextStyle(fontSize: 16)),
                ],
              ),
              // DropdownButton<String>(
              //   value: _selected_Lang,
              //   borderRadius: BorderRadius.circular(15),
              //   // elevation: 15,x
              //   // hint: Text("Select"),
              //   underline: Container(),
              //   icon: Icon(Icons.keyboard_arrow_down_rounded),
              //   items:
              //       Lang_Support.map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem(child: Text(value), value: value);
              //       }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _selected_Lang = newValue!;
              //     });
              //   },
              // ),
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

      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
        child: ListView.builder(
          itemCount: cropList.length,
          itemBuilder: (context, index) {
            final curr_crop = cropList[index];
            return ListingListTiles(
              isOffered: curr_crop.isOffered,
              Crop_name: curr_crop.cropName,
              government_price: curr_crop.govt_value,
              Date_of_listing: curr_crop.date,
              your_price: curr_crop.yoursValue,
              quantity: curr_crop.quantity,
              path_image: curr_crop.imagePath,
              Offered_price: curr_crop.offeredValue,
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green.shade400,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }
}
