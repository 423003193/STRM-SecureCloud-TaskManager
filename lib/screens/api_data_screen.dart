import 'package:flutter/material.dart';
import '../models/api_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class ApiDataScreen extends StatefulWidget {
  const ApiDataScreen({super.key});

  @override
  State<ApiDataScreen> createState() => _ApiDataScreenState();
}

class _ApiDataScreenState extends State<ApiDataScreen> {
  late Future<List<ApiPost>> _futurePosts;
  bool _isOfflineData = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _futurePosts = ApiService.fetchPosts().then((posts) {
      // If fewer than 10 posts came back, it's our sample data
      if (mounted && posts.length <= 8) {
        setState(() => _isOfflineData = true);
      }
      return posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        title: const Text('API Resources'),
        backgroundColor: AppColors.secondaryBg,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: () {
              setState(() {
                _isOfflineData = false;
                _loadPosts();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status banner
          if (_isOfflineData)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: AppColors.accent.withValues(alpha: 0.15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: AppColors.accent, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Showing cached sample data (offline)',
                    style: TextStyle(color: AppColors.accent, fontSize: 12),
                  ),
                ],
              ),
            ),
          // Posts list
          Expanded(
            child: FutureBuilder<List<ApiPost>>(
              future: _futurePosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _loadPosts()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return Card(
                        color: AppColors.glassmorphism,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.accent.withValues(alpha: 0.2),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.accent.withValues(alpha: 0.2),
                            child: Text(
                              '${post.id}',
                              style:
                                  const TextStyle(color: AppColors.accent),
                            ),
                          ),
                          title: Text(
                            post.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              post.body,
                              style: const TextStyle(
                                  color: AppColors.textSecondary),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No Data',
                      style: TextStyle(color: AppColors.textSecondary)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
