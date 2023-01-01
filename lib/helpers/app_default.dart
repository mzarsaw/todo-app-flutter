import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo.dart';

class AppDefaults {
  static const String dialogTitle = 'Add Todo';
  static const String appTitle = 'Todo app';
  static const String usingStream = 'using Stream';
  static const String usingBloc = 'using Bloc';
  static const String usingBloobit = 'using Bloobit';
  static const String todoList = 'Todo list';
  static const Todo testTodo = Todo(title: 'test', isCompleted: true);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
