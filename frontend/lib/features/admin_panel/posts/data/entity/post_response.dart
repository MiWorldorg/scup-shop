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

  PostManageResponse({
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

  factory PostManageResponse.fromJson(Map<String, dynamic> json) {
    return PostManageResponse(
      postPicture: json['post_picture'],
      id: json['id'],
      authorId: json['author_id'],
      categoryId: json['category_id'],
      slug: json['slug'],
      title: json['title'],
      published: json['published'],
      summary: json['summary'],
      content: json['content'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'category_id': categoryId,
      'slug': slug,
      'title': title,
      'published': published,
      'summary': summary,
      'content': content,
    };
  }
}
