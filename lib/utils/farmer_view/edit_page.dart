import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class EditListingPage extends StatefulWidget {
  final String cropName;
  final String dateOfListing;
  final double yourPrice;
  final double governmentPrice;
  final double quantity;
  final String pathImage;

  const EditListingPage({
    Key? key,
    required this.cropName,
    required this.dateOfListing,
    required this.yourPrice,
    required this.governmentPrice,
    required this.quantity,
    required this.pathImage,
  }) : super(key: key);

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _cropNameController;
  late TextEditingController _quantityController;
  late TextEditingController _yourPriceController;
  late TextEditingController _customCategoryController;

  // Image selection
  File? _selectedImage;
  String? _imagePath;
  bool _isLoadingPrice = false;

  // Dropdown options
  final List<String> _cropCategories = [
    'Grains',
    'Vegetables',
    'Fruits',
    'Pulses',
    'Oilseeds',
    'Other',
  ];
  late String _selectedCategory;

  // Government price (would typically come from an API)
  late double _governmentPrice;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing values
    _cropNameController = TextEditingController(text: widget.cropName);
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _yourPriceController = TextEditingController(
      text: widget.yourPrice.toString(),
    );
    _customCategoryController = TextEditingController();

    // Set initial values
    _governmentPrice = widget.governmentPrice;
    _selectedCategory = _getCategoryFromCropName(widget.cropName);
    _imagePath = widget.pathImage;

    // If the path is a file path (not an asset), create a File object
    if (!widget.pathImage.startsWith('lib/assets/')) {
      _selectedImage = File(widget.pathImage);
    }
  }

  // Helper method to determine category from crop name
  String _getCategoryFromCropName(String cropName) {
    // This is a simple example - in a real app, you might have a more sophisticated mapping
    if (cropName.toLowerCase().contains('rice') ||
        cropName.toLowerCase().contains('wheat') ||
        cropName.toLowerCase().contains('grain')) {
      return 'Grains';
    } else if (cropName.toLowerCase().contains('tomato') ||
        cropName.toLowerCase().contains('potato') ||
        cropName.toLowerCase().contains('onion')) {
      return 'Vegetables';
    } else if (cropName.toLowerCase().contains('apple') ||
        cropName.toLowerCase().contains('mango') ||
        cropName.toLowerCase().contains('banana')) {
      return 'Fruits';
    }

    return 'Other'; // Default category
  }

  Future<void> _updateGovernmentPrice() async {
    setState(() {
      _isLoadingPrice = true;
    });

    // Simulate API call with delay
    await Future.delayed(Duration(milliseconds: 800));

    // This would typically be an API call based on crop name and category
    setState(() {
      // Generate a slightly different price each time to simulate real-time updates
      _governmentPrice =
          widget.governmentPrice *
          (0.95 + (0.1 * (DateTime.now().millisecond / 1000)));
      _isLoadingPrice = false;
    });
  }

  Future<void> _pickImage() async {
    // Determine which permission to request based on Android version
    Permission permission;
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else {
      permission = Permission.photos;
    }

    // Request permission
    var status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      if (!status.isGranted) {
        // Show a message that permission was denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied. Cannot select image.')),
        );
        return;
      }
    }

    // Try to pick image
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imagePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  // Helper function to check Android version
  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt >= 33; // Android 13 is API level 33
    }
    return false;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create an updated listing object
      final updatedListing = {
        'cropName': _cropNameController.text,
        'quantity': double.parse(_quantityController.text),
        'yourPrice': double.parse(_yourPriceController.text),
        'governmentPrice': _governmentPrice,
        'dateOfListing': widget.dateOfListing, // Keep original date
        'isOffered': false, // Reset offer status on edit
        'pathImage':
            _imagePath ??
            widget
                .pathImage, // Use new image if selected, otherwise keep original
        'category':
            _selectedCategory == 'Other'
                ? _customCategoryController.text
                : _selectedCategory,
      };

      // Return the updated listing to the previous screen
      Navigator.pop(context, updatedListing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
        backgroundColor: colors.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image selection
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.greenAccent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          _selectedImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : widget.pathImage.startsWith('lib/assets/')
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  widget.pathImage,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 50,
                                    color: colors.tertiary,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Change Crop Image',
                                    style: TextStyle(
                                      color: colors.tertiary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Crop category dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCategory,
                          items:
                              _cropCategories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                                _updateGovernmentPrice();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    if (_selectedCategory == 'Other')
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _customCategoryController,
                          decoration: InputDecoration(
                            labelText: 'Specify Category',
                            labelStyle: TextStyle(color: Colors.grey.shade900),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (_selectedCategory == 'Other' &&
                                (value == null || value.isEmpty)) {
                              return 'Please specify the category';
                            }
                            return null;
                          },
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16),

                // Crop name
                TextFormField(
                  controller: _cropNameController,
                  decoration: InputDecoration(
                    labelText: 'Crop Name',
                    labelStyle: TextStyle(color: Colors.grey.shade900),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.eco, color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter crop name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Update government price when crop name changes
                    _updateGovernmentPrice();
                  },
                ),

                SizedBox(height: 16),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity (kg)',
                    labelStyle: TextStyle(color: Colors.grey.shade900),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.scale, color: Colors.grey.shade600),
                    suffixText: 'kg',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Quantity must be greater than zero';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Your price
                TextFormField(
                  controller: _yourPriceController,
                  decoration: InputDecoration(
                    labelText: 'Your Price (per kg)',
                    labelStyle: TextStyle(color: Colors.grey.shade900),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Color(0xFF0b6c0c),
                    ),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than zero';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24),

                // Government price display with refresh button
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withAlpha(85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Government Price:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          _isLoadingPrice
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                '₹ ${_governmentPrice.toStringAsFixed(2)} per kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.black54),
                            onPressed:
                                _isLoadingPrice ? null : _updateGovernmentPrice,
                            tooltip: 'Refresh price',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.tertiary,
                      foregroundColor: colors.onTertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Update Listing',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _yourPriceController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }
}
