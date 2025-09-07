import 'package:flutter/foundation.dart';
import '../../../core/services/database_service.dart';
import '../models/post.dart';

/// Repository for accessing and manipulating forum posts
class ForumRepository {
  final FirebaseFirestore _firestore;
  final String _postsCollection = 'posts';

  ForumRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Initialize the repository
  Future<void> initialize() async {
    if (_firestore == FirebaseFirestore.instance) {
      await _firestore.initialize();
    }
  }

  /// Fetch all posts, ordered by creation time (newest first)
  Future<List<Post>> fetchPosts() async {
    try {
      await initialize();
      final postsQuery = await _firestore
          .collection(_postsCollection)
          .get();

      final docs = postsQuery.docs;
      
      // Sort manually since we're using a mock firestore
      docs.sort((a, b) {
        final aData = a.data();
        final bData = b.data();
        final aTime = aData['createdAt'];
        final bTime = bData['createdAt'];
        
        // Compare creation dates
        DateTime aDateTime, bDateTime;
        
        if (aTime is DateTime) {
          aDateTime = aTime;
        } else {
          aDateTime = DateTime.now();
        }
        
        if (bTime is DateTime) {
          bDateTime = bTime;
        } else {
          bDateTime = DateTime.now();
        }
        
        return bDateTime.compareTo(aDateTime);  // Descending order
      });

      return docs
          .map((doc) => Post.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  /// Create a new post
  Future<String?> createPost(Post post) async {
    try {
      await initialize();
      final docRef = await _firestore.collection(_postsCollection).add(post.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating post: $e');
      return null;
    }
  }

  /// Add a reply to an existing post
  Future<bool> addReply(String postId, Reply reply) async {
    try {
      await initialize();
      final postDoc = await _firestore.collection(_postsCollection).doc(postId).get();
      if (!postDoc.exists) {
        return false;
      }

      final post = Post.fromMap(postDoc.data(), postDoc.id);
      final updatedReplies = [...post.replies, reply];

      await _firestore.collection(_postsCollection).doc(postId).update({
        'replies': updatedReplies.map((reply) => reply.toMap()).toList(),
      });

      return true;
    } catch (e) {
      debugPrint('Error adding reply: $e');
      return false;
    }
  }

  /// Handle reactions (like/dislike) for a post
  Future<bool> handleReaction(
    String postId,
    String userId,
    String reactionType,
  ) async {
    try {
      await initialize();
      final postDoc = await _firestore.collection(_postsCollection).doc(postId).get();
      if (!postDoc.exists) {
        return false;
      }

      final post = Post.fromMap(postDoc.data(), postDoc.id);
      final alreadyLiked = post.likedBy.contains(userId);
      final alreadyDisliked = post.dislikedBy.contains(userId);

      int likesChange = 0;
      int dislikesChange = 0;
      List<String> newLikedBy = [...post.likedBy];
      List<String> newDislikedBy = [...post.dislikedBy];

      if (reactionType == 'like') {
        if (alreadyLiked) {
          // Unlike
          newLikedBy.remove(userId);
          likesChange = -1;
        } else {
          // Like
          newLikedBy.add(userId);
          likesChange = 1;

          // Remove dislike if exists
          if (alreadyDisliked) {
            newDislikedBy.remove(userId);
            dislikesChange = -1;
          }
        }
      } else if (reactionType == 'dislike') {
        if (alreadyDisliked) {
          // Remove dislike
          newDislikedBy.remove(userId);
          dislikesChange = -1;
        } else {
          // Dislike
          newDislikedBy.add(userId);
          dislikesChange = 1;

          // Remove like if exists
          if (alreadyLiked) {
            newLikedBy.remove(userId);
            likesChange = -1;
          }
        }
      }

      final newLikes = post.likes + likesChange;
      final newDislikes = post.dislikes + dislikesChange;

      await _firestore.collection(_postsCollection).doc(postId).update({
        'likes': newLikes,
        'dislikes': newDislikes,
        'likedBy': newLikedBy,
        'dislikedBy': newDislikedBy,
      });

      return true;
    } catch (e) {
      debugPrint('Error handling reaction: $e');
      return false;
    }
  }
}