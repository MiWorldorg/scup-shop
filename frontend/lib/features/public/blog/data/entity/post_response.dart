class PostResponse {
  final String postPicture;
  final int authorId;
  final int categoryId;
  final String slug;
  final String title;
  final String published;
  final String summary;
  final String content;

  PostResponse({
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
      postPicture: json['post_picture'],
      authorId: json['author_id'],
      categoryId: json['category_id'],
      slug: json['slug'],
      title: json['title'],
      published: json['published'],
      summary: json['summary'],
      content: json['content'],
    );
  }
}
