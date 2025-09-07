import '../../../core/models/timestamp.dart';

/// Model representing a forum post author
class PostAuthor {
  final String id;
  final String name;

  PostAuthor({
    required this.id,
    required this.name,
  });

  /// Create a PostAuthor from a map (from database)
  factory PostAuthor.fromMap(Map<String, dynamic> map) {
    return PostAuthor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  /// Convert a PostAuthor to a map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Model representing a reply to a forum post
class Reply {
  final String id;
  final String content;
  final PostAuthor author;
  final DateTime createdAt;

  Reply({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  /// Create a Reply from a map (from database)
  factory Reply.fromMap(Map<String, dynamic> map) {
    // Handle timestamp conversion
    DateTime convertTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDateTime();
      } else if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return Reply(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      author: PostAuthor.fromMap(map['author'] ?? {}),
      createdAt: convertTimestamp(map['createdAt']),
    );
  }

  /// Convert a Reply to a map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author.toMap(),
      'createdAt': Timestamp.fromDateTime(createdAt),
    };
  }
}

/// Model representing a forum post
class Post {
  final String id;
  final String title;
  final String content;
  final PostAuthor author;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<String> dislikedBy;
  final List<Reply> replies;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.likedBy,
    required this.dislikedBy,
    required this.replies,
  });

  /// Create a Post from a map (from database)
  factory Post.fromMap(Map<String, dynamic> map, String id) {
    final List<Reply> replies = [];
    if (map['replies'] != null) {
      for (var replyMap in (map['replies'] as List<dynamic>)) {
        replies.add(Reply.fromMap(replyMap));
      }
    }

    // Handle timestamp conversion
    DateTime convertTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDateTime();
      } else if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return Post(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: PostAuthor.fromMap(map['author'] ?? {}),
      likes: map['likes']?.toInt() ?? 0,
      dislikes: map['dislikes']?.toInt() ?? 0,
      createdAt: convertTimestamp(map['createdAt']),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      dislikedBy: List<String>.from(map['dislikedBy'] ?? []),
      replies: replies,
    );
  }

  /// Convert a Post to a map for database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author.toMap(),
      'likes': likes,
      'dislikes': dislikes,
      'createdAt': Timestamp.fromDateTime(createdAt),
      'likedBy': likedBy,
      'dislikedBy': dislikedBy,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  /// Create a copy of this Post with the given field values updated
  Post copyWith({
    String? title,
    String? content,
    PostAuthor? author,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
    List<String>? likedBy,
    List<String>? dislikedBy,
    List<Reply>? replies,
  }) {
    return Post(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      dislikedBy: dislikedBy ?? this.dislikedBy,
      replies: replies ?? this.replies,
    );
  }
}