import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum_ai/app/app.dart';

void main() {
  testWidgets('Splash screen shows app branding', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MomentumAIApp()));

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Momentum AI'), findsOneWidget);
    expect(find.text('Your personal productivity assistant'), findsOneWidget);
  });
}
