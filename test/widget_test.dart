import 'package:flutter_test/flutter_test.dart';
import 'package:davron_ishi/main.dart';

void main() {
  testWidgets('Multi-level Catalog 3-step navigation test', (WidgetTester tester) async {
    // 1. Build app and verify Level 1 (Asosiy kategoriyalar)
    await tester.pumpWidget(const CatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('Каталог меню'), findsOneWidget);
    expect(find.text('1-daraja: Asosiy kategoriyalar'), findsOneWidget);
    expect(find.text('Elektronika'), findsOneWidget);
    expect(find.text('Maishiy texnika'), findsOneWidget);

    // 2. Tap 'Elektronika' -> Navigate to Level 2 (Sub-kategoriyalar)
    await tester.tap(find.text('Elektronika'));
    await tester.pumpAndSettle();

    expect(find.text('2-daraja: Kerakli bo\'limni tanlang'), findsOneWidget);
    expect(find.text('Smartfonlar va gadjetlar'), findsOneWidget);
    expect(find.text('Noutbuklar va kompyuterlar'), findsOneWidget);

    // 3. Tap 'Smartfonlar va gadjetlar' -> Navigate to Level 3 (Yakuniy mahsulotlar)
    await tester.tap(find.text('Smartfonlar va gadjetlar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('3-daraja:'), findsOneWidget);
    expect(find.textContaining('Apple iPhone 15 Pro Max'), findsOneWidget);

    // 4. Test Back navigation via AppBar leading button
    await tester.tap(find.byTooltip('Orqaga qaytish'));
    await tester.pumpAndSettle();

    // Now back at Level 2
    expect(find.text('2-daraja: Kerakli bo\'limni tanlang'), findsOneWidget);

    // Tap back again -> Now back at Level 1
    await tester.tap(find.byTooltip('Orqaga qaytish'));
    await tester.pumpAndSettle();

    expect(find.text('1-daraja: Asosiy kategoriyalar'), findsOneWidget);
  });
}
