import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ListingDetailPage extends StatefulWidget {
  final bool isOffered;
  final String cropName;
  final String dateOfListing;
  final double yourPrice;
  final double governmentPrice;
  final double? offeredPrice;
  final String pathImage;
  final double quantity;

  const ListingDetailPage({
    Key? key,
    required this.isOffered,
    required this.cropName,
    required this.dateOfListing,
    required this.yourPrice,
    required this.governmentPrice,
    this.offeredPrice,
    required this.quantity,
    required this.pathImage,
  }) : super(key: key);

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  double? marketPrice;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMarketPrice();
  }

  Future<void> fetchMarketPrice() async {
    // Simulating API call to fetch market price
    try {
      // In a real app, replace this URL with your actual API endpoint
      final response = await http.get(
        Uri.parse(
          'https://api.example.com/market-prices/${widget.cropName.toLowerCase()}',
        ),
      );

      // Simulate delay for demonstration
      await Future.delayed(Duration(seconds: 1));

      if (response.statusCode == 200) {
        // Parse the response
        // final data = jsonDecode(response.body);
        // marketPrice = data['price'];

        // For demonstration, using a random price based on government price
        marketPrice =
            widget.governmentPrice *
            (0.9 + (0.2 * (DateTime.now().millisecond / 1000)));
      } else {
        // If server returns an error
        marketPrice = null;
      }
    } catch (e) {
      // If there's a network error, use a fallback price
      marketPrice = widget.governmentPrice * 1.05;
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Details'),
        backgroundColor: colors.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image section
            Container(
              width: double.infinity,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                color: colors.primaryContainer.withOpacity(0.3),
              ),
              child: Image.asset(widget.pathImage, fit: BoxFit.contain),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Crop name and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.cropName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Offer Received",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Quantity and listing date
                  _buildInfoRow(
                    context,
                    Icons.scale,
                    "Quantity",
                    "${widget.quantity} kg",
                  ),

                  _buildInfoRow(
                    context,
                    Icons.calendar_today,
                    "Listed on",
                    widget.dateOfListing,
                  ),

                  Divider(height: 32),

                  // Price information
                  Text(
                    "Price Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Your price
                  _buildPriceCard(
                    context,
                    "Your Price",
                    "₹${widget.yourPrice}",
                    Colors.green,
                    "per kg",
                  ),

                  SizedBox(height: 12),

                  // Government price
                  _buildPriceCard(
                    context,
                    "Government Price",
                    "₹${widget.governmentPrice}",
                    Colors.blue,
                    "per kg",
                  ),

                  // Market price (fetched from internet)
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Market Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        isLoading
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  marketPrice != null
                                      ? "₹${marketPrice!.toStringAsFixed(2)}"
                                      : "Not available",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                Text(
                                  "per kg",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),

                  // Offered price if available
                  SizedBox(height: 12),
                  _buildPriceCard(
                    context,
                    "Offered Price",
                    "₹${widget.offeredPrice}",
                    Colors.orange,
                    "per kg",
                  ),

                  SizedBox(height: 24),

                  // Total value
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.primaryContainer),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Value",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "₹${(widget.yourPrice * widget.quantity).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Offered Total: ₹${(widget.offeredPrice! * widget.quantity).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Action buttons for offered listings
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Accept offer functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "Accept Offer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Decline offer functionality
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            "Decline Offer",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    BuildContext context,
    String title,
    String price,
    Color priceColor,
    String unit,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: priceColor,
                ),
              ),
              Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
