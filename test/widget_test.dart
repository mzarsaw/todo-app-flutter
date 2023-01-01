// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/helpers/todo_item_widget.dart';

import 'package:my_todo_app/main.dart';

void main() {
  group('Test with StreamBuilder', () {
    testWidgets('Test add todo items with different State management',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await testTodo(tester, AppDefaults.usingStream);
    });
  });
  group('Test with Bloc', () {
    testWidgets('Test add todo items with different State management',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await testTodo(tester, AppDefaults.usingBloc);
    });
  });
  group('Test with Bloobit', () {
    testWidgets('Test add todo items with different State management',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await testTodo(tester, AppDefaults.usingBloobit);
    });
  });
}

Future<void> testTodo(WidgetTester tester, String stateManagement) async {
  await tester.pumpWidget(compose()<MyApp>());
  await tester.tap(find.text(stateManagement));
  await tester.pumpAndSettle();
  // Verify that have one todo item
  expect(find.byType(TodoItemWidget), findsOneWidget);

  // Tap the '+' icon to show input dialog
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  // Verify input dialog shown
  expect(find.byType(AlertDialog), findsOneWidget);

  // input text
  await tester.enterText(find.byType(TextField), AppDefaults.newItem);
  await tester.pump();
  //Ensure text typing
  expect(find.text(AppDefaults.newItem), findsOneWidget);
  // Tap on Add button to add new Todo item
  await tester.tap(find.text(AppDefaults.add));
  await tester.pump();
  //Verify input dialog closed;
  expect(find.byType(AlertDialog), findsNothing);
  //Verify new Todo item added
  expect(find.text(AppDefaults.newItem), findsOneWidget);

  //Tap Todo item to change status to uncompleted
  await tester.tap(find.byIcon(Icons.check_box));
  await tester.pump();
  //Verify there is no Completed item
  expect(find.byIcon(Icons.check_box), findsNothing);
  //Verify all items are uncompleted
  expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(2));
  // delete last one by long pressing the item
  await tester.longPress(find.text(AppDefaults.newItem));
  await tester.pump();
  //Verify item deleteion and one item remains
  expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
  //Tap on add button to add new Todo item
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  //Verify input dialog shown
  expect(find.byType(AlertDialog), findsOneWidget);
  //input text
  await tester.enterText(find.byType(TextField), AppDefaults.newItem);
  await tester.pump();
  //Verify text typing
  expect(find.text(AppDefaults.newItem), findsOneWidget);
  //Tap on cancel
  await tester.tap(find.text(AppDefaults.cancel));
  await tester.pump();
  //Verify input dialog closed
  expect(find.byType(AlertDialog), findsNothing);
  //Verify no item added
  expect(find.text(AppDefaults.newItem), findsNothing);
}
