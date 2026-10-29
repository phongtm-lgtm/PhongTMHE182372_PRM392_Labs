import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key, this.apiService});

  final ApiService? apiService;

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService _apiService;
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _postsFuture = _apiService.fetchPosts();
  }

  Future<void> _reload() async {
    final future = _apiService.fetchPosts();
    setState(() {
      _postsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder renders the error; refresh callbacks complete normally.
    }
  }

  @override
  void dispose() {
    if (widget.apiService == null) _apiService.close();
    super.dispose();
  }

  void _showDetails(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Bài viết #${post.id}')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TÁC GIẢ #${post.userId}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                Text(
                  post.body,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài viết'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Đang tải dữ liệu…'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            return _StatusView(
              icon: Icons.cloud_off_outlined,
              title: 'Không thể tải bài viết',
              message: error is ApiException
                  ? error.message
                  : 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              onRetry: _reload,
            );
          }

          final posts = snapshot.data ?? const <Post>[];
          if (posts.isEmpty) {
            return _StatusView(
              icon: Icons.inbox_outlined,
              title: 'Chưa có bài viết',
              message: 'Danh sách hiện đang trống. Hãy tải lại sau.',
              onRetry: _reload,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Text(
                  '${posts.length} bài viết',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(child: Text('${post.id}')),
                          title: Text(
                            post.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showDetails(post),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
