class PostResponse {
  final String postPicture;
  final int authorId;
  final int categoryId;
  final String slug;
  final String title;
  final String published;
  final String summary;
  final String content;

  const PostResponse({
    required this.postPicture,
    required this.authorId,
    required this.categoryId,
    required this.slug,
    required this.title,
    required this.published,
    required this.summary,
    required this.content,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      postPicture: json['post_picture']?.toString() ?? '',
      authorId: _integer(json['author_id']),
      categoryId: _integer(json['category_id']),
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      published: json['published']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}

int _integer(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
