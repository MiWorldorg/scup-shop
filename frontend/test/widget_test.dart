import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:sculpture_shop/main.dart';

void main() {
  testWidgets('MyApp builds and shows the landing shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
