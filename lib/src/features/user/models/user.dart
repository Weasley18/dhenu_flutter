/// User model for the application
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  /// Create a User from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  /// Convert User to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
    };
  }

  /// Create a copy of this User with the given field values updated
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
