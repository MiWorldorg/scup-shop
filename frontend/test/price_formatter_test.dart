import 'package:flutter_test/flutter_test.dart';
import 'package:sculpture_shop/core/formatters/price_formatter.dart';

void main() {
  group('PriceFormatter.amount', () {
    test('groups whole-dollar USD values', () {
      expect(PriceFormatter.amount(1250), '1,250');
      expect(PriceFormatter.amount(1650000), '1,650,000');
    });

    test('keeps zero and small values readable', () {
      expect(PriceFormatter.amount(0), '0');
      expect(PriceFormatter.amount(185), '185');
    });

    test('preserves a negative sign', () {
      expect(PriceFormatter.amount(-1250), '-1,250');
    });
  });
}
