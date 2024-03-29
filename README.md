# **A journey through state management and widget testing in Flutter**
## **Introduction**

As a Flutter developer, you are no doubt familiar with the many challenges that come with building robust, scalable, and reliable mobile apps. One area that has garnered a lot of attention in the Flutter community is state management: the process of managing, storing and updating the data that drives an app's behavior. In this article, we'll explore some of the state management approaches in Flutter, using a side project – a [to-do app](https://github.com/mzarsaw/todo-app-flutter) – as a case study.

To compare the different approaches, I decided to develop a to-do app using two state management libraries: [Bloc](https://pub.dev/packages/flutter_bloc), [Bloobit](https://github.com/MelbourneDeveloper/bloobit), and [StreamBuilder](https://pub.dev/packages/rxdart) as a solution that most of state managements are based on it. As I worked on the project, I also paid close attention to unit testing and widget testing, two essential practices for ensuring the quality and reliability of a Flutter app. In this article, I'll share my experiences with each of these approaches and offer some insights into what I learned along the way. Whether you're a seasoned Flutter developer or just starting out, I hope you'll find this case study to be informative and useful.

> **Note:** I chose to include Bloobit in this case study because it is a relatively new and innovative state management library. One of the things that I really like about Bloobit is its simplicity - the entire codebase is less than 170 lines, which makes it easy to understand and use. I believe that developing an app with Bloobit could be a really interesting and rewarding experience, especially for developers who are new to Flutter or who are looking for a lightweight, easy-to-use state management solution. If you are interested in giving Bloobit a try, I recommend taking a look at the code in the project repository and trying it out for yourself.

In this case study, I decided to focus on three state management approaches Bloc, Bloobit, and StreamBuilder. While there are other popular options available, such as Riverpod and Getx, I felt that these three approaches offered a good balance of popularity, innovation, and diversity. I have some experience with Getx, but not with Riverpod, and the feedback from the community seems to be similar. Ultimately, I wanted to compare state management approaches that had the most to offer and a new one. also, that would be of the most interest and value to other Flutter developers.

## **Project description**

Now that we've introduced the project and discussed the state management approaches we'll be exploring, let's dive into the project itself. The first thing we'll look at is the user interface (UI). Like most to-do apps, the UI for this project is fairly simple, consisting of a list of tasks and a form for adding new tasks.

The app has a home page that includes three buttons, which allow the user to navigate to the different implementations of the Todo pages. These pages showcase the three state management approaches we are comparing in this case study: Bloc, Bloobit, and StreamBuilder. By clicking on each button, the user can see how the same functionality has been implemented using a different state management approach. This allows us to compare the approaches side by side and see how they stack up in terms of ease of use, performance, and scalability.

In the "`state_management`" folder, I've implemented the three state management approaches that we are comparing in this case study: Bloc, Bloobit, and StreamBuilder. This folder contains four files: `todo_bloc.dart`, `todo_bloobit.dart`, `todo_stream.dart`, and `todo.dart`. The last file, `todo.dart`, defines the states and events that are used by the other three files to manage the app's state. By organizing the code in this way, it is easy to see how each approach handles state management and how it compares to the others.

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/state_managements/todo.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/services/dialog_service.dart';

// The BLoC that manages the state and events for the todo app
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final IDialogService dialogService;
  TodoBloc({required this.dialogService})
      : super(
            TodoState(todos: <Todo>[AppDefaults.testTodo], isEditing: false)) {
    on<AddTodo>(_addTodo);
    on<DeleteTodo>((event, emit) =>
        emit(state.copyWith(todos: state.todos..remove(event.todo))));
    on<ToggleTodo>(_toggleTodo);
    on<ToggleEditMode>(
        (event, emit) => emit(state.copyWith(isEditing: !state.isEditing)));
  }
  Future _addTodo(AddTodo add, Emitter<TodoState> emit) async {
    var title =
        await dialogService.showInputDialog(title: AppDefaults.dialogTitle);
    if (title != null) {
      emit(state.copyWith(
          todos: state.todos..add(Todo(title: title, isCompleted: false))));
    }
  }

  void _toggleTodo(ToggleTodo toggleTodo, Emitter<TodoState> emit) {
    final newTodos = state.todos
        .map((t) => t == toggleTodo.todo
            ? Todo(title: t.title, isCompleted: !t.isCompleted)
            : t)
        .toList();
    emit(state.copyWith(todos: newTodos));
  }
}
```

The "`screens`" folder contains the UI implementations for each of the three state management approaches. Each screen uses the corresponding state management code from the "`state_management`" folder to manage its state and update the UI as needed. This allows us to see how each state management approach is used in practice and how it affects the overall user experience.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/state_managements/todo.dart';
import 'package:my_todo_app/state_managements/todo_bloc.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/helpers/todo_item_widget.dart';

class TodoListBlocView extends StatelessWidget {
  final IocContainer container;
  const TodoListBlocView({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    final todoBloc = container<TodoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('${AppDefaults.todoList} ${AppDefaults.usingBloc}'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        bloc: todoBloc,
        builder: (context, state) {
          final todos = state.todos;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItemWidget(
                todo: todo,
                onPressed: () => todoBloc.add(ToggleTodo(todo: todo)),
                onLongPress: () => todoBloc.add(DeleteTodo(todo: todo)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => todoBloc.add(AddTodo()),
      ),
    );
  }
}
```

To ensure a clear separation between business and UI logic, the app includes a DialogService that is responsible for showing an input dialog to the user and managing the user's input. This helps to keep the UI code focused on rendering the app's interface and leave the handling of user input to a separate layer of the app. By following this pattern, it is easier to maintain and modify the codebase over time, as well as to test different parts of the app independently.

```dart
import 'package:flutter/material.dart';
import 'package:my_todo_app/helpers/app_default.dart';

abstract class IDialogService {
  Future<String?> showInputDialog(
      {VoidCallback? onAdd, VoidCallback? onCancel, String? title});
}

class DialogService implements IDialogService {
  final GlobalKey<NavigatorState> navigatorKey;
  DialogService({required this.navigatorKey});
  @override
  Future<String?> showInputDialog(
      {VoidCallback? onAdd, VoidCallback? onCancel, String? title}) {
    title = title ?? AppDefaults.dialogTitle;
    return showDialog<String?>(
      context: navigatorKey.currentState!.context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: Text(title!),
          content: TextField(
            controller: textController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (onCancel != null) {
                  onCancel();
                }
                Navigator.pop<String?>(context);
              },
              child: const Text(AppDefaults.cancel),
            ),
            TextButton(
              onPressed: () {
                if (onAdd != null) {
                  onAdd();
                }
                Navigator.pop<String?>(context, textController.text);
              },
              child: const Text(AppDefaults.add),
            ),
          ],
        );
      },
    );
  }
}
```

As a .NET developer, I am a fan of dependency injection (DI) as a way to promote loose coupling between classes and facilitate testing. When developing this Flutter app, I decided to use a DI library called "`IocContainer`" which was written by my friend Christian Findlay. This library has proven to be fast and easy to use, and it has helped me to ensure that my code is well-structured and easy to maintain. If you are interested in learning more about "`IocContainer`" and how it compares to other DI libraries for Flutter, you can check out the package repository [here](https://github.com/MelbourneDeveloper/ioc_container). As you can see all of the class instantiating is in `IocContainer`

```dart
import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/state_managements/todo_bloc.dart';
import 'package:my_todo_app/state_managements/todo_bloobit.dart';
import 'package:my_todo_app/state_managements/todo_stream.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/screens/home_page.dart';
import 'package:my_todo_app/screens/todo_bloobit.dart';
import 'package:my_todo_app/screens/todo_flutter_bloc.dart';
import 'package:my_todo_app/screens/todo_stream_builder.dart';
import 'package:my_todo_app/services/dialog_service.dart';

void main() => runApp(compose()<MyApp>());

class MyApp extends StatelessWidget {
  final IocContainer container;

  const MyApp({Key? key, required this.container}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: AppDefaults.navigatorKey,
        title: 'Todo App Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: container<HomePage>(),
      );
}

IocContainer compose() => (IocContainerBuilder()
      ..addSingleton(
          (container) => TodoStream(dialogService: container<IDialogService>()))
      ..addSingleton(
          (container) => TodoBloc(dialogService: container<IDialogService>()))
      ..addSingleton((container) =>
          TodoBloobit(dialogService: container<IDialogService>()))
      ..add((container) =>
          TodoListBloobitView(todoBloobit: container<TodoBloobit>()))
      ..add((container) => TodoListBlocView(container: container))
      ..add((container) => TodoListStreamBuilderView(container: container))
      ..add((container) => HomePage(container: container))
      ..addSingleton((container) => MyApp(container: container))
      ..add<IDialogService>(
          (_) => DialogService(navigatorKey: AppDefaults.navigatorKey)))
    .toContainer();
```

## **Test App**

As we move into the testing phase of this project, we must decide whether to write unit tests or widget tests. On one hand, we could write unit tests for each of the state management approaches to ensure that they are working correctly. On the other hand, we could write a widget test to test the overall app and see how it performs in a more realistic setting. After some consideration, I have decided to start with a simple widget test to get a feel for how it works and what it can reveal about the app's behavior. This will allow me to make an informed decision about whether to pursue further testing with unit tests or to focus on other aspects of the project.

```dart
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
```

As you can see, by writing less than 100 lines of code, we are able to test the entire app and achieve a code coverage of 93%. This is a testament to the power of widget tests, which allow us to test the app's behavior from the perspective of the user, without having to worry about dependencies on the app's code. By relying solely on the UI, widget tests are fast, reliable, and easy to maintain, making them a valuable tool for any Flutter developer.

One issue that we encountered during testing is that there is some code in the app that cannot be tested because it is not used in the UI. Specifically, there is no way to edit a task in the app, so the code that handles this functionality is never executed. While this code is not necessarily harmful, it does represent "dead" code that is not being tested and could potentially cause problems in the future. In order to achieve 100% code coverage, it would be best to delete this unused code and focus on testing the parts of the app that are actually being used. By doing so, we can ensure that our tests are thorough and focused, and we can have confidence that the app is working as intended.

As a general rule, it is a good practice to delete any code that cannot be reached through the user interface (UI). Code that is not being used by the app serves no purpose and can only cause confusion and maintenance issues in the future. By regularly reviewing the codebase and deleting unused code, we can keep the app lean, well-organized, and easy to understand. This is especially important in a team setting, where multiple developers may be working on the same codebase and it is important to have a clear separation between active and inactive code. By following this practice, we can ensure that our code is maintainable, scalable, and reliable.

After further consideration, I have decided that writing unit tests may not be the most efficient approach for this project. If we were to add a new state management approach or make changes to the app's logic, we would need to spend a lot of time updating the unit tests or troubleshooting why certain tests are failing. In my experience, UI changes are relatively rare, while changes to business logic are much more common. Therefore, I think it makes more sense to use widget tests, which are better suited to testing the overall app and can be easily updated as the app evolves. By using widget tests, we can ensure that the app is functioning correctly without having to maintain a large and potentially fragile set of unit tests.

## **Conclusion**

As a software developer with over 10 years of experience in both .NET and Flutter, I have learned that it is important not to get too bogged down in specific rules or approaches. When it comes to developing Flutter apps, the choice of state management is a crucial one, but it is not always clear which approach is the best. Each state management library has its own pros and cons, and the right choice will depend on the specific needs and goals of the project. In my experience, it is best to choose a state management library that is simple and developer-friendly, rather than trying to use a more complex library in the hopes of achieving better performance.

In terms of testing, I have found that unit tests are not always the best choice. Requirements for an app can change rapidly, and this can lead to a lot of time spent updating unit tests. While unit tests can be useful for verifying the behavior of critical or isolated parts of an app, they do not guarantee that the app will work correctly as a whole. Instead, I recommend using widget tests to test the overall behavior of the app. These tests are more closely tied to the UI, which tends to change less frequently than the app's underlying logic. By using widget tests, we can ensure that the app is functioning correctly and deliver it to users faster.
