import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';
import '../providers/user_provider.dart';
import '../data/dummy_data.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();

  String _selectedType = 'rent';
  String _selectedCategory = 'apartment';
  int _bedrooms = 1;
  int _bathrooms = 1;
  List<String> _selectedAmenities = [];
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoggedIn) {
            return _buildLoginPrompt();
          }
          return _buildAddPropertyForm();
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Login to add properties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Join our community of property owners and list your properties',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to login - handled by bottom navigation
              },
              icon: const Icon(Icons.login),
              label: const Text('Login / Sign Up'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPropertyForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Property Information'),
            _buildTextField(
              controller: _titleController,
              label: 'Property Title',
              hint: 'e.g., Luxury 3BHK Apartment',
              icon: Icons.title,
              validator: (value) => value?.isEmpty == true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe your property...',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) => value?.isEmpty == true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Property Type & Category'),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Type',
                    value: _selectedType,
                    items: const ['rent', 'sale', 'pg'],
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Category',
                    value: _selectedCategory,
                    items: const ['apartment', 'house', 'villa', 'studio', 'pg', 'penthouse', 'commercial'],
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Price & Details'),
            _buildTextField(
              controller: _priceController,
              label: 'Price (₹)',
              hint: _selectedType == 'rent' || _selectedType == 'pg' ? 'Monthly rent' : 'Total price',
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty == true) return 'Please enter price';
                if (double.tryParse(value!) == null) return 'Please enter valid price';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _areaController,
              label: 'Area (sq ft)',
              hint: 'Property area in square feet',
              icon: Icons.square_foot,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty == true) return 'Please enter area';
                if (double.tryParse(value!) == null) return 'Please enter valid area';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCounterField('Bedrooms', _bedrooms, (value) => setState(() => _bedrooms = value)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCounterField('Bathrooms', _bathrooms, (value) => setState(() => _bathrooms = value)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Location'),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Complete address with city and state',
              icon: Icons.location_on,
              maxLines: 2,
              validator: (value) => value?.isEmpty == true ? 'Please enter address' : null,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Amenities'),
            _buildAmenitiesSelector(),
            const SizedBox(height: 20),

            _buildSectionTitle('Images'),
            _buildImageSelector(),
            const SizedBox(height: 20),

            _buildSectionTitle('Owner Information'),
            _buildTextField(
              controller: _ownerNameController,
              label: 'Owner Name',
              hint: 'Property owner name',
              icon: Icons.person,
              validator: (value) => value?.isEmpty == true ? 'Please enter owner name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _ownerPhoneController,
              label: 'Phone Number',
              hint: '+91 9876543210',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty == true ? 'Please enter phone number' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _ownerEmailController,
              label: 'Email',
              hint: 'owner@example.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty == true) return 'Please enter email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitProperty,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Property', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.category),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.toUpperCase()),
        );
      }).toList(),
    );
  }

  Widget _buildCounterField(String label, int value, Function(int) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DummyData.popularAmenities.map((amenity) {
        final isSelected = _selectedAmenities.contains(amenity);
        return FilterChip(
          label: Text(amenity),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedAmenities.add(amenity);
              } else {
                _selectedAmenities.remove(amenity);
              }
            });
          },
          selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
          checkmarkColor: const Color(0xFF2E7D32),
        );
      }).toList(),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Images'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _addSampleImages,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Use Sample'),
            ),
          ],
        ),
        if (_imageUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('${_imageUrls.length} images selected'),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrls[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageUrls.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      
      // In a real app, you would upload these images to a server
      // For demo purposes, we'll use placeholder URLs
      setState(() {
        for (int i = 0; i < images.length; i++) {
          _imageUrls.add('https://images.unsplash.com/photo-${DateTime.now().millisecondsSinceEpoch + i}?w=800');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error picking images')),
      );
    }
  }

  void _addSampleImages() {
    setState(() {
      _imageUrls = [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      ];
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _addressController.clear();
      _areaController.clear();
      _ownerNameController.clear();
      _ownerPhoneController.clear();
      _ownerEmailController.clear();
      _selectedType = 'rent';
      _selectedCategory = 'apartment';
      _bedrooms = 1;
      _bathrooms = 1;
      _selectedAmenities.clear();
      _imageUrls.clear();
    });
  }

  void _submitProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final property = Property(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        type: _selectedType,
        category: _selectedCategory,
        images: _imageUrls,
        address: _addressController.text,
        latitude: 19.0760 + (DateTime.now().millisecondsSinceEpoch % 1000) / 10000, // Random nearby location
        longitude: 72.8777 + (DateTime.now().millisecondsSinceEpoch % 1000) / 10000,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        area: double.parse(_areaController.text),
        amenities: _selectedAmenities,
        ownerName: _ownerNameController.text,
        ownerPhone: _ownerPhoneController.text,
        ownerEmail: _ownerEmailController.text,
        postedDate: DateTime.now(),
        isAvailable: true,
        isFeatured: false,
      );

      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      propertyProvider.addProperty(property);
      userProvider.addMyProperty(property.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting property: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}