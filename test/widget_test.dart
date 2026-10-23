import 'package:flutter_test/flutter_test.dart';
import 'package:cinepedia/main.dart';

void main() {
  testWidgets('CinePedia auth smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CinePediaApp());
    expect(find.text('CinePedia'), findsOneWidget);
    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });
}
