import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../providers/forum_providers.dart';
import '../../auth/providers/auth_provider.dart';
import 'reply_list.dart';

class PostItem extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback onRefresh;

  const PostItem({
    super.key,
    required this.post,
    required this.onRefresh,
  });

  @override
  ConsumerState<PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem> {
  bool _isExpanded = false;
  bool _isReplying = false;
  final TextEditingController _replyController = TextEditingController();
  bool _isSubmittingReply = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final hasUserLiked = currentUser != null && widget.post.likedBy.contains(currentUser.uid);
    final hasUserDisliked = currentUser != null && widget.post.dislikedBy.contains(currentUser.uid);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            if (!_isExpanded) {
              _isReplying = false;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post header (author and timestamp)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.post.author.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Text(
                    _formatDate(widget.post.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Post title
              Text(
                widget.post.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Post content
              Text(
                widget.post.content,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              
              // Post stats and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like button
                  InkWell(
                    onTap: () => _handleReaction('like'),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            hasUserLiked ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: hasUserLiked ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.likes.toString(),
                            style: TextStyle(
                              color: hasUserLiked ? Colors.red : Colors.grey,
                              fontWeight: hasUserLiked ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Dislike button
                  InkWell(
                    onTap: () => _handleReaction('dislike'),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            hasUserDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            size: 20,
                            color: hasUserDisliked ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.dislikes.toString(),
                            style: TextStyle(
                              color: hasUserDisliked ? Colors.blue : Colors.grey,
                              fontWeight: hasUserDisliked ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Reply count
                  Row(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.replies.length.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  // Reply button
                  TextButton.icon(
                    onPressed: () {
                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You need to be signed in to reply'),
                          ),
                        );
                        return;
                      }
                      
                      setState(() {
                        _isExpanded = true;
                        _isReplying = !_isReplying;
                      });
                    },
                    icon: const Icon(Icons.reply),
                    label: Text(_isReplying ? 'Cancel' : 'Reply'),
                  ),
                ],
              ),
              
              // Expanded section for replies
              if (_isExpanded) ...[
                const Divider(height: 24),
                ReplyList(replies: widget.post.replies),
                
                // Reply form
                if (_isReplying) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _isSubmittingReply
                            ? null
                            : () => _submitReply(),
                        child: _isSubmittingReply
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  Future<void> _handleReaction(String reactionType) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be signed in to react to posts'),
        ),
      );
      return;
    }

    final result = await ref.read(
      handleReactionProvider(
        (postId: widget.post.id, reactionType: reactionType),
      ),
    );

    if (result && context.mounted) {
      widget.onRefresh();
    }
  }

  Future<void> _submitReply() async {
    final replyContent = _replyController.text.trim();
    if (replyContent.isEmpty) return;

    setState(() {
      _isSubmittingReply = true;
    });

    try {
      final result = await ref.read(
        addReplyProvider(
          (postId: widget.post.id, content: replyContent),
        ),
      );

      if (result && mounted) {
        _replyController.clear();
        widget.onRefresh();
        setState(() {
          _isReplying = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingReply = false;
        });
      }
    }
  }
}
