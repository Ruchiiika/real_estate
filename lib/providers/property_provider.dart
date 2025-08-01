import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../data/dummy_data.dart';

class PropertyProvider with ChangeNotifier {
  List<Property> _properties = DummyData.properties;
  List<Property> _filteredProperties = DummyData.properties;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedType = 'All';
  double _minPrice = 0;
  double _maxPrice = 10000000;
  List<String> _selectedAmenities = [];

  List<Property> get properties => _properties;
  List<Property> get filteredProperties => _filteredProperties;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  List<String> get selectedAmenities => _selectedAmenities;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
    notifyListeners();
  }

  void toggleAmenity(String amenity) {
    if (_selectedAmenities.contains(amenity)) {
      _selectedAmenities.remove(amenity);
    } else {
      _selectedAmenities.add(amenity);
    }
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedType = 'All';
    _minPrice = 0;
    _maxPrice = 10000000;
    _selectedAmenities.clear();
    _filteredProperties = _properties;
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProperties = _properties.where((property) {
      // Search query filter
      bool matchesSearch = _searchQuery.isEmpty ||
          property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      bool matchesCategory = _selectedCategory == 'All' ||
          property.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Type filter
      bool matchesType = _selectedType == 'All' ||
          property.type.toLowerCase() == _selectedType.toLowerCase();

      // Price filter
      bool matchesPrice = property.price >= _minPrice && property.price <= _maxPrice;

      // Amenities filter
      bool matchesAmenities = _selectedAmenities.isEmpty ||
          _selectedAmenities.every((amenity) => 
              property.amenities.any((propAmenity) => 
                  propAmenity.toLowerCase().contains(amenity.toLowerCase())));

      return matchesSearch && matchesCategory && matchesType && matchesPrice && matchesAmenities;
    }).toList();
  }

  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProperty(Property property) {
    _properties.add(property);
    _applyFilters();
    notifyListeners();
  }

  void updateProperty(Property property) {
    final index = _properties.indexWhere((p) => p.id == property.id);
    if (index != -1) {
      _properties[index] = property;
      _applyFilters();
      notifyListeners();
    }
  }

  void deleteProperty(String id) {
    _properties.removeWhere((property) => property.id == id);
    _applyFilters();
    notifyListeners();
  }

  List<Property> getFeaturedProperties() {
    return _properties.where((property) => property.isFeatured).toList();
  }

  List<Property> getRecentProperties() {
    final sortedProperties = List<Property>.from(_properties);
    sortedProperties.sort((a, b) => b.postedDate.compareTo(a.postedDate));
    return sortedProperties.take(5).toList();
  }

  List<Property> getPropertiesByType(String type) {
    return _properties.where((property) => property.type.toLowerCase() == type.toLowerCase()).toList();
  }

  List<Property> getPropertiesByCategory(String category) {
    return _properties.where((property) => property.category.toLowerCase() == category.toLowerCase()).toList();
  }

  void incrementViews(String propertyId) {
    final property = getPropertyById(propertyId);
    if (property != null) {
      final updatedProperty = property.copyWith(views: (property.views ?? 0) + 1);
      updateProperty(updatedProperty);
    }
  }
}