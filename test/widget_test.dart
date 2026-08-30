import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guesst/app.dart';

void main() {
  testWidgets('Home screen shows the Play button', (WidgetTester tester) async {
    await tester.pumpWidget(const GuessTApp());
    await tester.pumpAndSettle();

    expect(find.text('GuessT'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Play'), findsOneWidget);
  });
}
