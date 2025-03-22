class CropData {
  final bool isOffered;
  final String imagePath; // Path to the image
  final String cropName; // Crop name (e.g., "Grain")
  final String date; // Date (e.g., "21st Jan 2025")
  final double yoursValue; // Value for "Yours"
  final double offeredValue; // Value for "Offered"
  final double govt_value; // Value for "Government"
  final double quantity;

  final String? Seller_name;
  final String? Desciption_crop;

  CropData({
    required this.imagePath,
    required this.cropName,
    required this.date,
    required this.yoursValue,
    required this.offeredValue,
    required this.govt_value,
    this.Seller_name,
    required this.isOffered,
    this.Desciption_crop,
    required this.quantity,
  });
}
