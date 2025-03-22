import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListingListTiles extends StatelessWidget {
  bool isOffered;
  String Crop_name;
  String Date_of_listing;
  double your_price;
  double government_price;
  double? Offered_price;
  String path_image;
  double quantity;
  ListingListTiles({
    super.key,
    required this.isOffered,
    required this.Crop_name,
    required this.Date_of_listing,
    required this.your_price,
    required this.government_price,
    this.Offered_price,
    required this.quantity,
    required this.path_image
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        // extentRatio: ,
        children: [
          SlidableAction(
            label: "Delete",
            onPressed: (context) {
              // Delete ka Option
              print("hello");
            },
            icon: Icons.delete,
            backgroundColor: colors.onPrimaryFixed,
            // foregroundColor: ,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),

      child: Container(
        // height: 65,
        decoration: BoxDecoration(
          // color: Colors.amber, // Background color
          color:
              isOffered
                  ? colors.onSecondaryContainer
                  : colors.onSurfaceVariant, // Background color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD3D3D3),
              // color: Colors.,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween, // Ensures space between left and right content
          children: [
            // Row to hold the Avatar and List1 together on the left
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    // 'lib/assets/crops/grain_crop1.png',
                    path_image
                  ),
                ),
                SizedBox(width: 8), // Spacing between avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Crop_name,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        // Spacer(),
                        Text(" | $quantity kg", style: TextStyle(fontSize: 20)),
                      ],
                    ),

                    Text(
                      Date_of_listing,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Use Spacer or Expanded to push the column to the far right
            SizedBox(width: 12),

            // Column for YP and GP at the end
            Container(
              margin: EdgeInsets.only(right: 6),
              child:
                  isOffered
                      ? Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Yours",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "$your_price",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment,
                            children: [
                              Text(
                                "Offered",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              // SizedBox(height: 5),
                              Text(
                                "$Offered_price",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center, // Align text to the right in the column
                        children: [
                          Text(
                            "$your_price",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$government_price",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
