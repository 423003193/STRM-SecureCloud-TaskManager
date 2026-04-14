import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_model.dart';

class ApiService {
  static const String url = 'https://jsonplaceholder.typicode.com/posts';

  /// Hardcoded sample data used as fallback when network is unavailable.
  static List<ApiPost> get _samplePosts => [
    ApiPost(
      id: 1,
      title: 'Implementing Secure Cloud Storage',
      body: 'Cloud storage security involves encryption at rest and in transit, '
          'access control policies, and regular security audits to protect data.',
    ),
    ApiPost(
      id: 2,
      title: 'Best Practices for Mobile Authentication',
      body: 'Modern mobile apps should use multi-factor authentication, biometric '
          'verification, and secure token storage for user safety.',
    ),
    ApiPost(
      id: 3,
      title: 'Offline-First Architecture in Flutter',
      body: 'Building offline-first apps requires local databases like SQLite, '
          'synchronization queues, and conflict resolution strategies.',
    ),
    ApiPost(
      id: 4,
      title: 'RESTful API Design Principles',
      body: 'Well-designed REST APIs use proper HTTP methods, status codes, '
          'versioning, and consistent response formats for reliability.',
    ),
    ApiPost(
      id: 5,
      title: 'Firebase Integration for Real-Time Sync',
      body: 'Firebase provides real-time database capabilities, authentication '
          'services, and cloud functions for scalable mobile backends.',
    ),
    ApiPost(
      id: 6,
      title: 'Cross-Platform Development with Flutter',
      body: 'Flutter enables building natively compiled applications for mobile, '
          'web, and desktop from a single Dart codebase.',
    ),
    ApiPost(
      id: 7,
      title: 'Data Encryption Standards for Mobile Apps',
      body: 'AES-256 encryption, secure key management, and TLS 1.3 are essential '
          'components of modern mobile application security.',
    ),
    ApiPost(
      id: 8,
      title: 'Task Management System Architecture',
      body: 'Effective task management systems implement CRUD operations, priority '
          'queues, deadline tracking, and collaborative features.',
    ),
  ];

  /// Fetches posts from the API. Falls back to sample data on failure.
  static Future<List<ApiPost>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ApiPost.fromJson(json)).toList();
      } else {
        // Server error → return sample data
        return _samplePosts;
      }
    } catch (_) {
      // Network error / timeout → return sample data
      return _samplePosts;
    }
  }
}
