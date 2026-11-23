import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/controllers/posts_manage_controller.dart';

class PostManageEditorDialog extends StatefulWidget {
  final PostManageResponse? post;

  const PostManageEditorDialog({super.key, this.post});

  @override
  State<PostManageEditorDialog> createState() => _PostManageEditorDialogState();
}

class _PostManageEditorDialogState extends State<PostManageEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<PostsManageController>();
  late final TextEditingController _title;
  late final TextEditingController _slug;
  late final TextEditingController _summary;
  late final TextEditingController _content;
  late final TextEditingController _image;
  int? _categoryId;
  late bool _isPublished;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    _title = TextEditingController(text: post?.title ?? '');
    _slug = TextEditingController(text: post?.slug ?? '');
    _summary = TextEditingController(text: post?.summary ?? '');
    _content = TextEditingController(text: post?.content ?? '');
    _image = TextEditingController(text: post?.postPicture ?? '');
    _categoryId = post?.categoryId;
    _isPublished = post?.isPublished ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _slug.dispose();
    _summary.dispose();
    _content.dispose();
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.post == null ? 'Create post' : 'Edit post'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(_title, 'Title'),
                const SizedBox(height: 12),
                _field(_slug, 'URL slug'),
                const SizedBox(height: 12),
                Obx(_categoryField),
                const SizedBox(height: 12),
                _field(_summary, 'Short summary', maxLines: 3),
                const SizedBox(height: 12),
                _field(_content, 'Article content', maxLines: 8),
                const SizedBox(height: 12),
                _field(_image, 'Image path (optional)', required: false),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Publish this post'),
                  subtitle: const Text(
                    'Drafts are visible only in the administrator panel.',
                  ),
                  value: _isPublished,
                  onChanged: (value) => setState(() => _isPublished = value),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.post == null ? 'Create post' : 'Save changes'),
        ),
      ],
    );
  }

  Widget _categoryField() {
    if (_controller.isLoadingCategories.value) {
      return const LinearProgressIndicator();
    }
    if (_controller.categories.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.categoriesError.value ?? 'No post categories found.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          TextButton.icon(
            onPressed: _controller.fetchCategories,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Load categories again'),
          ),
        ],
      );
    }

    final categories = _controller.categories;
    final selectedId = categories.any((category) => category.id == _categoryId)
        ? _categoryId
        : categories.first.id;
    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Category'),
      items: categories
          .map(
            (category) => DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.title),
            ),
          )
          .toList(growable: false),
      onChanged: (value) => setState(() => _categoryId = value),
      validator: (value) => value == null ? 'Choose a category.' : null,
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (!required) return null;
        if (value == null || value.trim().isEmpty) {
          return '$label is required.';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final previousPublishedAt = widget.post?.published;
    final payload = <String, dynamic>{
      'category_id': _categoryId,
      'title': _title.text.trim(),
      'slug': _slug.text.trim(),
      'summary': _summary.text.trim(),
      'content': _content.text.trim(),
      'post_picture': _image.text.trim().isEmpty ? null : _image.text.trim(),
      'published': !_isPublished
          ? null
          : (widget.post?.isPublished == true
                ? previousPublishedAt
                : DateTime.now().toUtc().toIso8601String()),
    };

    try {
      if (widget.post == null) {
        await _controller.createPost(payload);
      } else {
        payload['id'] = widget.post!.id;
        await _controller.updatePost(payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = ApiResponse.userFacingError(error);
        _isSaving = false;
      });
    }
  }
}
