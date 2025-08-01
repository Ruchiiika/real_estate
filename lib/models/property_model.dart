class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String type; // rent, sale, pg
  final String category; // apartment, house, villa, etc.
  final List<String> images;
  final String address;
  final double latitude;
  final double longitude;
  final int bedrooms;
  final int bathrooms;
  final double area; // in sq ft
  final List<String> amenities;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final DateTime postedDate;
  final bool isAvailable;
  final bool isFeatured;
  final String? videoUrl;
  final int? views;
  final List<String>? tags;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.category,
    required this.images,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.postedDate,
    this.isAvailable = true,
    this.isFeatured = false,
    this.videoUrl,
    this.views,
    this.tags,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      type: json['type'],
      category: json['category'],
      images: List<String>.from(json['images']),
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area'].toDouble(),
      amenities: List<String>.from(json['amenities']),
      ownerName: json['ownerName'],
      ownerPhone: json['ownerPhone'],
      ownerEmail: json['ownerEmail'],
      postedDate: DateTime.parse(json['postedDate']),
      isAvailable: json['isAvailable'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      videoUrl: json['videoUrl'],
      views: json['views'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'category': category,
      'images': images,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'amenities': amenities,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'postedDate': postedDate.toIso8601String(),
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'videoUrl': videoUrl,
      'views': views,
      'tags': tags,
    };
  }

  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? type,
    String? category,
    List<String>? images,
    String? address,
    double? latitude,
    double? longitude,
    int? bedrooms,
    int? bathrooms,
    double? area,
    List<String>? amenities,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    DateTime? postedDate,
    bool? isAvailable,
    bool? isFeatured,
    String? videoUrl,
    int? views,
    List<String>? tags,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      category: category ?? this.category,
      images: images ?? this.images,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      amenities: amenities ?? this.amenities,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      postedDate: postedDate ?? this.postedDate,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      videoUrl: videoUrl ?? this.videoUrl,
      views: views ?? this.views,
      tags: tags ?? this.tags,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final List<String> wishlist;
  final List<String> myProperties;
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.wishlist = const [],
    this.myProperties = const [],
    required this.joinDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      wishlist: List<String>.from(json['wishlist'] ?? []),
      myProperties: List<String>.from(json['myProperties'] ?? []),
      joinDate: DateTime.parse(json['joinDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'wishlist': wishlist,
      'myProperties': myProperties,
      'joinDate': joinDate.toIso8601String(),
    };
  }
}