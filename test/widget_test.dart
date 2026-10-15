import 'package:flutter_test/flutter_test.dart';
import 'package:build_test/main.dart';

void main() {
  testWidgets('NovaStore smoke test - loads store and products', (WidgetTester tester) async {
    await tester.pumpWidget(const NovaStoreApp());
    expect(find.text('NovaStore'), findsOneWidget);
    expect(find.text('Pro Wireless Headphones'), findsOneWidget);
  });
}
