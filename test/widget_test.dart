import 'package:flutter_test/flutter_test.dart';
import 'package:strm/main.dart';

void main() {
  testWidgets('Smoke test for STRMApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const STRMApp());

    // Should find the text STRM LOGIN initially
    expect(find.text('STRM LOGIN'), findsOneWidget);
  });
}
