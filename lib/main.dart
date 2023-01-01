import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo_bloc_package.dart';
import 'package:my_todo_app/bloc/todo_bloobit.dart';
import 'package:my_todo_app/bloc/todo_stream.dart';
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
