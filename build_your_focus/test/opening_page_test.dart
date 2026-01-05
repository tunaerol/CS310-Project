import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:build_your_focus/screens/auth/opening_page.dart';

void main() {
  testWidgets('Opening Page renders onboarding components', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400); //set a fixed size for test environment
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MaterialApp(home: FirstOpening()));

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsWidgets);
    expect(find.byType(GestureDetector), findsWidgets);

    addTearDown(tester.view.resetPhysicalSize);
  });
}