import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pickers_demo/main.dart';

void main() {
  testWidgets('picker demo smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('flutter_pickers Demo'), findsOneWidget);
    expect(find.text('地址选择器'), findsOneWidget);
    expect(find.text('省市区三级联动'), findsOneWidget);
  });
}
