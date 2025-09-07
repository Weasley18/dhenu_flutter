import '../../../core/models/timestamp.dart';

/// Model class for a cow
class Cow {
  final String id;
  final String name;
  final String breed;
  final DateTime birthDate;
  final String? tagNumber;
  final String? notes;
  final double? milkProduction;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  Cow({
    required this.id,
    required this.name,
    required this.breed,
    required this.birthDate,
    this.tagNumber,
    this.notes,
    this.milkProduction,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  /// Factory to create a Cow from a Map, typically from database
  factory Cow.fromMap(Map<String, dynamic> map, String id) {
    // Handle timestamp conversion
    DateTime convertTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDateTime();
      } else if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return Cow(
      id: id,
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      birthDate: convertTimestamp(map['birthDate']),
      tagNumber: map['tagNumber'],
      notes: map['notes'],
      milkProduction: map['milkProduction']?.toDouble(),
      ownerId: map['ownerId'] ?? '',
      createdAt: convertTimestamp(map['createdAt']),
      updatedAt: convertTimestamp(map['updatedAt']),
      imageUrl: map['imageUrl'],
    );
  }

  /// Convert this Cow instance to a Map to store in database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'birthDate': Timestamp.fromDateTime(birthDate),
      'tagNumber': tagNumber,
      'notes': notes,
      'milkProduction': milkProduction,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDateTime(createdAt),
      'updatedAt': Timestamp.fromDateTime(updatedAt),
      'imageUrl': imageUrl,
    };
  }

  /// Create a copy of this Cow with the specified fields updated
  Cow copyWith({
    String? name,
    String? breed,
    DateTime? birthDate,
    String? tagNumber,
    String? notes,
    double? milkProduction,
    String? imageUrl,
  }) {
    return Cow(
      id: id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      tagNumber: tagNumber ?? this.tagNumber,
      notes: notes ?? this.notes,
      milkProduction: milkProduction ?? this.milkProduction,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Calculate the age of the cow in years
  double get age {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    return difference.inDays / 365.25;
  }

  /// Format the age as a string
  String get ageDisplay {
    final ageYears = age;
    if (ageYears < 1) {
      final ageMonths = (ageYears * 12).round();
      return '$ageMonths months';
    } else {
      return '${ageYears.toStringAsFixed(1)} years';
    }
  }
}