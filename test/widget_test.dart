import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/main.dart';

void main() {
  testWidgets('App renders splash screen with AAK text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    expect(find.text('AAK'), findsOneWidget);
    expect(find.byType(MyApp), findsOneWidget);
  });
}
