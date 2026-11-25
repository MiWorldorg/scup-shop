class PostManageResponse {
  final String postPicture;
  final int id;
  final int authorId;
  final int categoryId;
  final String slug;
  final String title;
  final String published;
  final String summary;
  final String content;

  const PostManageResponse({
    required this.authorId,
    required this.postPicture,
    required this.id,
    required this.categoryId,
    required this.slug,
    required this.title,
    required this.published,
    required this.summary,
    required this.content,
  });

  bool get isPublished => published.isNotEmpty;

  factory PostManageResponse.fromJson(Map<String, dynamic> json) {
    return PostManageResponse(
      postPicture: json['post_picture']?.toString() ?? '',
      id: _integer(json['id']),
      authorId: _integer(json['author_id']),
      categoryId: _integer(json['category_id']),
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      published: json['published']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'slug': slug,
    'title': title,
    'published': isPublished ? published : null,
    'summary': summary,
    'content': content,
    'post_picture': postPicture,
  };
}

class PostCategoryResponse {
  final int id;
  final String title;

  const PostCategoryResponse({required this.id, required this.title});

  factory PostCategoryResponse.fromJson(Map<String, dynamic> json) =>
      PostCategoryResponse(
        id: _integer(json['id']),
        title: json['title']?.toString() ?? '',
      );
}

int _integer(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
