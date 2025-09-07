import '../../../core/models/timestamp.dart';

/// Model for a product enquiry
class Enquiry {
  final String name;
  final String contact;
  final String message;
  final DateTime createdAt;

  Enquiry({
    required this.name,
    required this.contact,
    required this.message,
    required this.createdAt,
  });

  /// Create an Enquiry from a map (from database)
  factory Enquiry.fromMap(Map<String, dynamic> map) {
    // Handle timestamp conversion
    DateTime convertTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDateTime();
      } else if (value is DateTime) {
        return value;
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    return Enquiry(
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      message: map['message'] ?? '',
      createdAt: map['createdAt'] != null
          ? convertTimestamp(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert the enquiry to a map for database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Model for a marketplace product
class Product {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? location;
  final int enquiries;
  final DateTime createdAt;
  final String userId;
  final List<Enquiry> enquiryList;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.location,
    required this.enquiries,
    required this.createdAt,
    required this.userId,
    List<Enquiry>? enquiryList,
  }) : enquiryList = enquiryList ?? [];

  /// Create a Product from a map (from database)
  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    // Convert enquiries list from map to Enquiry objects
    List<Enquiry> enquiryList = [];
    if (map['enquiryList'] != null) {
      for (var enquiry in map['enquiryList']) {
        enquiryList.add(Enquiry.fromMap(enquiry));
      }
    }

    // Handle timestamp conversion
    DateTime convertTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDateTime();
      } else if (value is DateTime) {
        return value;
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    return Product(
      id: docId,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'],
      location: map['location'],
      enquiries: map['enquiries']?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? convertTimestamp(map['createdAt'])
          : DateTime.now(),
      userId: map['userId'] ?? '',
      enquiryList: enquiryList,
    );
  }

  /// Convert the product to a map for database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'location': location,
      'enquiries': enquiries,
      'createdAt': Timestamp.fromDateTime(createdAt),
      'userId': userId,
      'enquiryList': enquiryList.map((e) => e.toMap()).toList(),
    };
  }

  /// Create a copy of this Product with the given field values updated
  Product copyWith({
    String? name,
    String? category,
    String? description,
    String? location,
    int? enquiries,
    DateTime? createdAt,
    String? userId,
    List<Enquiry>? enquiryList,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      location: location ?? this.location,
      enquiries: enquiries ?? this.enquiries,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      enquiryList: enquiryList ?? this.enquiryList,
    );
  }
}

/// Model for a seller in the marketplace
class Seller {
  final String displayName;
  final String email;

  Seller({
    required this.displayName,
    required this.email,
  });

  /// Create a Seller from a map
  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      displayName: map['name'] ?? 'Unknown',
      email: map['email'] ?? '',
    );
  }
}