import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/connect.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

void main() {
  group('ApiResponse pagination', () {
    test('reads rows and Laravel resource meta pagination fields', () {
      final response = Response<dynamic>(
        statusCode: 200,
        body: {
          'code': 1,
          'data': {
            'data': [
              {'id': 12, 'name': 'Example'},
            ],
            'meta': {
              'current_page': 2,
              'last_page': 5,
              'total': 41,
            },
          },
        },
      );

      final result = ApiResponse.paginated(response);

      expect(result.rows, hasLength(1));
      expect(result.rows.first['id'], 12);
      expect(result.currentPage, 2);
      expect(result.lastPage, 5);
      expect(result.total, 41);
    });

    test('uses safe defaults when pagination metadata is absent', () {
      final result = ApiResponse.paginated(
        Response<dynamic>(
          statusCode: 200,
          body: {
            'code': 1,
            'data': [
              {'id': 1},
            ],
          },
        ),
      );

      expect(result.currentPage, 1);
      expect(result.lastPage, 1);
      expect(result.total, 1);
    });

    test('rejects malformed response envelopes', () {
      expect(
        () => ApiResponse.list(
          Response<dynamic>(statusCode: 200, body: {'unexpected': true}),
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('preserves server validation errors and status codes', () {
      expect(
        () => ApiResponse.ensureSuccess(
          Response<dynamic>(
            statusCode: 422,
            body: {'message': 'The submitted data is invalid.'},
          ),
        ),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 422)
              .having(
                (error) => error.message,
                'message',
                'The submitted data is invalid.',
              ),
        ),
      );
    });
  });

  group('PostManageResponse', () {
    test('accepts nullable image and draft publication fields', () {
      final post = PostManageResponse.fromJson({
        'id': 4,
        'author_id': 2,
        'category_id': 3,
        'slug': 'draft-story',
        'title': 'Draft story',
        'published': null,
        'summary': 'A summary',
        'content': 'Article content',
        'post_picture': null,
      });

      expect(post.postPicture, isEmpty);
      expect(post.isPublished, isFalse);
      expect(post.toJson()['published'], isNull);
    });

    test('parses a published post and serializes its timestamp', () {
      final post = PostManageResponse.fromJson({
        'id': 5,
        'author_id': 2,
        'category_id': 3,
        'slug': 'published-story',
        'title': 'Published story',
        'published': '2026-11-23T10:00:00Z',
        'summary': 'A summary',
        'content': 'Article content',
        'post_picture': 'assets/images/posts/rostam-post.png',
      });

      expect(post.isPublished, isTrue);
      expect(post.toJson()['published'], '2026-11-23T10:00:00Z');
    });
  });
}
