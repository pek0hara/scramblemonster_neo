import 'package:flutter_test/flutter_test.dart';
import 'package:scramblemonster_neo/main.dart';

void main() {
  testWidgets('App launches with game screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ScrambleMonsterApp());

    expect(find.text('スクランブルモンスター'), findsOneWidget);
    expect(find.text('スコア: '), findsOneWidget);
    expect(find.text('行動力: '), findsOneWidget);
  });
}
