import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../repositories/forum_repository.dart';
import '../../auth/providers/auth_provider.dart';

/// Provider for ForumRepository
final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  return ForumRepository();
});

/// Provider for fetching forum posts
final postsProvider = FutureProvider<List<Post>>((ref) async {
  final repository = ref.watch(forumRepositoryProvider);
  await repository.initialize(); // Make sure repository is initialized
  return await repository.fetchPosts();
});

/// Provider for sorting mechanism
enum SortType {
  mostRecent,
  mostOld,
  mostLiked,
  mostReplied,
}

/// Provider for the current sort type
final sortTypeProvider = StateProvider<SortType>((ref) {
  return SortType.mostRecent;
});

/// Provider for the sorted posts
final sortedPostsProvider = Provider<List<Post>>((ref) {
  final postsAsyncValue = ref.watch(postsProvider);
  final sortType = ref.watch(sortTypeProvider);
  
  return postsAsyncValue.when(
    data: (posts) {
      final List<Post> sortedPosts = List.from(posts);
      switch (sortType) {
        case SortType.mostRecent:
          sortedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortType.mostOld:
          sortedPosts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case SortType.mostLiked:
          sortedPosts.sort((a, b) => b.likes.compareTo(a.likes));
          break;
        case SortType.mostReplied:
          sortedPosts.sort((a, b) => b.replies.length.compareTo(a.replies.length));
          break;
      }
      return sortedPosts;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for the selected post (for showing replies)
final selectedPostIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Provider for create post form state
final newPostTitleProvider = StateProvider<String>((ref) {
  return '';
});

final newPostContentProvider = StateProvider<String>((ref) {
  return '';
});

/// Provider for reply form state
final replyContentProvider = StateProvider<String>((ref) {
  return '';
});

final replyingToPostIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Provider to create a new post
final createPostProvider = Provider.family<Future<String?>, ({String title, String content})>((ref, params) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final repository = ref.watch(forumRepositoryProvider);
  
  final post = Post(
    id: '', // Will be assigned by the repository
    title: params.title,
    content: params.content,
    author: PostAuthor(
      id: user.uid,
      name: user.displayName ?? 'Anonymous User',
    ),
    likes: 0,
    dislikes: 0,
    createdAt: DateTime.now(),
    likedBy: [],
    dislikedBy: [],
    replies: [],
  );
  
  return await repository.createPost(post);
});

/// Provider to add a reply to a post
final addReplyProvider = Provider.family<Future<bool>, ({String postId, String content})>((ref, params) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final repository = ref.watch(forumRepositoryProvider);
  
  final reply = Reply(
    id: 'reply-${DateTime.now().millisecondsSinceEpoch}',
    content: params.content,
    author: PostAuthor(
      id: user.uid,
      name: user.displayName ?? 'Anonymous User',
    ),
    createdAt: DateTime.now(),
  );
  
  return await repository.addReply(params.postId, reply);
});

/// Provider to handle post reactions (likes/dislikes)
final handleReactionProvider = Provider.family<Future<bool>, ({String postId, String reactionType})>((ref, params) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final repository = ref.watch(forumRepositoryProvider);
  
  return await repository.handleReaction(
    params.postId,
    user.uid,
    params.reactionType,
  );
});