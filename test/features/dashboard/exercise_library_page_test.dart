import 'package:fitness_trainer/features/dashboard/exercise_library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exercise library opens and filters on a narrow screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GymPage()));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Зал').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Дома').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField), 'Жим');
    await tester.pump();
    expect(find.text('Жим гантелей сидя'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
