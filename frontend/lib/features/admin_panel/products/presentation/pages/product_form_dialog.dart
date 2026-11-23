import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductListResponse? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  static const _bundledProductImages = [
    'assets/images/products/marble-think.png',
    'assets/images/products/marble-sit.png',
    'assets/images/products/ancient-greek -statues.png',
    'assets/images/products/butterfly-object.png',
    'assets/images/products/infinity-stone.png',
  ];
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<ProductListController>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _sku;
  late final TextEditingController _image;
  late final TextEditingController _price;
  late final TextEditingController _quantity;
  int? _categoryId;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _name = TextEditingController(text: product?.name ?? '');
    _description = TextEditingController(text: product?.desc ?? '');
    _sku = TextEditingController(text: product?.sku ?? '');
    _image = TextEditingController(
      text: product?.image ?? 'assets/images/products/marble-think.png',
    );
    _price = TextEditingController(text: product?.price.toString() ?? '');
    _quantity = TextEditingController(
      text: product?.quantity.toString() ?? '0',
    );
    _categoryId = product?.categoryId;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _sku.dispose();
    _image.dispose();
    _price.dispose();
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add product' : 'Edit product'),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width < 560
            ? MediaQuery.sizeOf(context).width - 48
            : 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _textField(_name, 'Product name'),
                const SizedBox(height: 12),
                _textField(
                  _description,
                  'Description',
                  maxLines: 3,
                  maxLength: 255,
                ),
                const SizedBox(height: 12),
                _textField(_sku, 'SKU'),
                const SizedBox(height: 12),
                Obx(_categoryField),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        _price,
                        'Price (USD)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _numberValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        _quantity,
                        'Stock quantity',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _numberValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _bundledProductImages.contains(_image.text)
                      ? _image.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Choose a bundled product image',
                  ),
                  items: _bundledProductImages
                      .map(
                        (path) => DropdownMenuItem<String>(
                          value: path,
                          child: Text(
                            path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) setState(() => _image.text = value);
                  },
                ),
                const SizedBox(height: 14),
                Text(
                  'Image preview',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Image.asset(
                    _image.text,
                    fit: BoxFit.contain,
                    semanticLabel: _name.text.isEmpty
                        ? 'Product image preview'
                        : '${_name.text} image preview',
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text('Asset preview unavailable'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _textField(
                  _image,
                  'Flutter asset path',
                  onChanged: (_) => setState(() {}),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
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
        Obx(
          () => FilledButton(
            onPressed:
                _isSaving ||
                    _controller.isLoadingCategories.value ||
                    _controller.categories.isEmpty
                ? null
                : _save,
            child: _isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.product == null ? 'Create product' : 'Save changes',
                  ),
          ),
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
            _controller.categoriesError.value ?? 'No product categories found.',
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
              child: Text(category.name),
            ),
          )
          .toList(growable: false),
      onChanged: (value) => setState(() => _categoryId = value),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required.';
            }
            return null;
          },
      decoration: InputDecoration(labelText: label),
    );
  }

  String? _numberValidator(String? value) {
    final number = int.tryParse(value ?? '');
    if (number == null || number < 0) {
      return 'Enter a valid non-negative number.';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      'desc': _description.text.trim(),
      'sku': _sku.text.trim(),
      'image': _image.text.trim(),
      'category_id':
          _controller.categories.any((category) => category.id == _categoryId)
          ? _categoryId
          : _controller.categories.first.id,
      'price': int.parse(_price.text),
      'quantity': int.parse(_quantity.text),
    };

    try {
      if (widget.product == null) {
        await _controller.createProduct(payload);
      } else {
        await _controller.updateProduct(widget.product!.id, payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = ApiResponse.userFacingError(error);
          _isSaving = false;
        });
      }
    }
  }
}
