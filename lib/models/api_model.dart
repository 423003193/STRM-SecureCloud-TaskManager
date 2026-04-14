class ApiPost {
  final int id;
  final String title;
  final String body;

  ApiPost({required this.id, required this.title, required this.body});

  factory ApiPost.fromJson(Map<String, dynamic> json) {
    return ApiPost(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
