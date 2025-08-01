import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property_model.dart';
import '../data/dummy_data.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<String> _wishlist = [];
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  List<String> get wishlist => _wishlist;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (_isLoggedIn) {
      // Load user data from preferences or use dummy data
      _currentUser = DummyData.dummyUser;
      _wishlist = prefs.getStringList('wishlist') ?? [];
      notifyListeners();
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setStringList('wishlist', _wishlist);
  }

  Future<bool> login(String email, String password) async {
    // Simulate login process
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, accept any email/password
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = User(
        id: DummyData.dummyUser.id,
        name: DummyData.dummyUser.name,
        email: email,
        phone: DummyData.dummyUser.phone,
        profileImage: DummyData.dummyUser.profileImage,
        wishlist: DummyData.dummyUser.wishlist,
        myProperties: DummyData.dummyUser.myProperties,
        joinDate: DummyData.dummyUser.joinDate,
      );
      await _saveUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    // Simulate signup process
    await Future.delayed(const Duration(seconds: 1));
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        joinDate: DateTime.now(),
      );
      await _saveUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    _wishlist.clear();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  void toggleWishlist(String propertyId) {
    if (_wishlist.contains(propertyId)) {
      _wishlist.remove(propertyId);
    } else {
      _wishlist.add(propertyId);
    }
    _saveUserData();
    notifyListeners();
  }

  bool isInWishlist(String propertyId) {
    return _wishlist.contains(propertyId);
  }

  List<Property> getWishlistProperties() {
    return DummyData.properties
        .where((property) => _wishlist.contains(property.id))
        .toList();
  }

  void updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        profileImage: profileImage ?? _currentUser!.profileImage,
        wishlist: _currentUser!.wishlist,
        myProperties: _currentUser!.myProperties,
        joinDate: _currentUser!.joinDate,
      );
      notifyListeners();
    }
  }

  void addMyProperty(String propertyId) {
    if (_currentUser != null) {
      final updatedProperties = List<String>.from(_currentUser!.myProperties);
      if (!updatedProperties.contains(propertyId)) {
        updatedProperties.add(propertyId);
        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          phone: _currentUser!.phone,
          profileImage: _currentUser!.profileImage,
          wishlist: _currentUser!.wishlist,
          myProperties: updatedProperties,
          joinDate: _currentUser!.joinDate,
        );
        notifyListeners();
      }
    }
  }

  void removeMyProperty(String propertyId) {
    if (_currentUser != null) {
      final updatedProperties = List<String>.from(_currentUser!.myProperties);
      updatedProperties.remove(propertyId);
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        wishlist: _currentUser!.wishlist,
        myProperties: updatedProperties,
        joinDate: _currentUser!.joinDate,
      );
      notifyListeners();
    }
  }

  List<Property> getMyProperties() {
    if (_currentUser == null) return [];
    
    return DummyData.properties
        .where((property) => _currentUser!.myProperties.contains(property.id))
        .toList();
  }
}