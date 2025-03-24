import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'detail_page_read_only.dart';
import 'package:gdg_solution/utils/farmer_view/Detail_Page_read_only.dart';
import 'package:gdg_solution/utils/farmer_view/edit_page.dart';


class ListingListTiles extends StatelessWidget {
  final bool isOffered;
  final String cropName;
  final String dateOfListing;
  final double yourPrice;
  final double governmentPrice;
  final double? offeredPrice;
  final String pathImage;
  final double quantity;
  final Function onDelete;

  ListingListTiles({
    Key? key,
    required this.isOffered,
    required this.cropName,
    required this.dateOfListing,
    required this.yourPrice,
    required this.governmentPrice,
    this.offeredPrice,
    required this.quantity,
    required this.pathImage,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        if (isOffered) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListingDetailPage(
                isOffered: isOffered,
                cropName: cropName,
                dateOfListing: dateOfListing,
                yourPrice: yourPrice,
                governmentPrice: governmentPrice,
                offeredPrice: offeredPrice,
                quantity: quantity,
                pathImage: pathImage,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditListingPage(
                cropName: cropName,
                dateOfListing: dateOfListing,
                yourPrice: yourPrice,
                governmentPrice: governmentPrice,
                quantity: quantity,
                pathImage: pathImage,
              ),
            ),
          );
        }
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              label: "Delete",
              onPressed: (context) {
                onDelete();
              },
              icon: Icons.delete,
              backgroundColor: colors.onPrimaryFixed,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isOffered ? colors.onSecondaryContainer : colors.onSurfaceVariant,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFD3D3D3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(pathImage),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            cropName,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(" | $quantity kg", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Text(
                        dateOfListing,
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
              SizedBox(width: 12),
              Container(
                margin: EdgeInsets.only(right: 6),
                child: isOffered
                    ? Row(
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
                                "$yourPrice",
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
                            children: [
                              Text(
                                "Offered",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "$offeredPrice",
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$yourPrice",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$governmentPrice",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
