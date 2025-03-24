import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _yourPriceController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

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
  String _selectedCategory = 'Grains';

  // Government price (would typically come from an API)
  double _governmentPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // Simulate fetching government price
    _updateGovernmentPrice();
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
      _governmentPrice = 20.0 + (DateTime.now().millisecond % 10);
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
      // Create a new listing object
      final newListing = {
        'cropName': _cropNameController.text,
        'quantity': double.parse(_quantityController.text),
        'yourPrice': double.parse(_yourPriceController.text),
        'governmentPrice': _governmentPrice,
        'dateOfListing': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'isOffered': false,
        'pathImage': _imagePath ?? 'lib/assets/crops/default_crop.png',
        'category':
            _selectedCategory == 'Other'
                ? _customCategoryController.text
                : _selectedCategory,
      };

      // Return the new listing to the previous screen
      Navigator.pop(context, newListing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Listing'),
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
                                    'Add Crop Image',
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
                          cursorColor: Colors.black54,

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
                  cursorColor: Colors.black54,
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
                  cursorColor: Colors.black54,

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
                  cursorColor: Colors.black54,

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
                          // color: COlors,
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
                      'Add Listing',
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
