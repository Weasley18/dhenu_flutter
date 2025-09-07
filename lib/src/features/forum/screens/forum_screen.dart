import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/forum_providers.dart';
import '../../auth/providers/auth_provider.dart';

// Simplified PostItem widget
class PostItem extends StatelessWidget {
  final dynamic post;
  
  const PostItem({super.key, required this.post});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}

// Simplified CreatePostDialog widget
class CreatePostDialog extends StatelessWidget {
  const CreatePostDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),
      content: const Text('Post creation dialog would go here'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class ForumScreen extends ConsumerWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);
    final sortType = ref.watch(sortTypeProvider);
    final sortedPosts = ref.watch(sortedPostsProvider);
    final isShowingSortDropdown = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
      body: Column(
        children: [
          // Sort Dropdown
          _buildSortDropdown(context, ref, sortType, isShowingSortDropdown),

          // Posts List
          Expanded(
            child: postsAsyncValue.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return _buildEmptyState(context);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(postsProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: sortedPosts.length,
                    itemBuilder: (context, index) {
                      final post = sortedPosts[index];
                      return PostItem(post: post);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading posts: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSortDropdown(
    BuildContext context,
    WidgetRef ref, 
    SortType sortType,
    ValueNotifier<bool> isShowingSortDropdown,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text('Sort by: '),
          InkWell(
            onTap: () {
              isShowingSortDropdown.value = !isShowingSortDropdown.value;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getSortTypeText(sortType)),
                  const SizedBox(width: 4.0),
                  const Icon(Icons.arrow_drop_down, size: 16.0),
                ],
              ),
            ),
          ),
          
          // Dropdown options
          ValueListenableBuilder(
            valueListenable: isShowingSortDropdown,
            builder: (context, isShowing, child) {
              if (!isShowing) return const SizedBox.shrink();
              
              return Positioned(
                top: 40.0,
                left: 70.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SortType.values.map((type) {
                      return InkWell(
                        onTap: () {
                          ref.read(sortTypeProvider.notifier).state = type;
                          isShowingSortDropdown.value = false;
                        },
                        child: Container(
                          width: 150.0,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Text(_getSortTypeText(type)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getSortTypeText(SortType sortType) {
    switch (sortType) {
      case SortType.mostRecent:
        return 'Most Recent';
      case SortType.mostOld:
        return 'Oldest First';
      case SortType.mostLiked:
        return 'Most Liked';
      case SortType.mostReplied:
        return 'Most Active';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 72.0,
            color: Colors.grey.withOpacity(0.7),
          ),
          const SizedBox(height: 16.0),
          Text(
            'No posts yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Be the first to start a discussion!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton.icon(
            onPressed: () => _showCreatePostDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create a Post'),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final currentUser = ProviderScope.containerOf(context).read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be signed in to create a post'),
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => const CreatePostDialog(),
    );
  }
}