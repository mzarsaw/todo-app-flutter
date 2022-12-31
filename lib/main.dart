import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo_bloc_package.dart';
import 'package:my_todo_app/bloc/todo_bloobit.dart';
import 'package:my_todo_app/bloc/todo_stream.dart';
import 'package:my_todo_app/screens/home_page.dart';

void main() {
  runApp(MyApp(
    container: compose(),
  ));
}

class MyApp extends StatelessWidget {
  final IocContainer container;

  const MyApp({Key? key, required this.container}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        container: container,
      ),
    );
  }
}

IocContainer compose() {
  final builder = IocContainerBuilder()
    ..addSingletonService(TodoStream())
    ..addSingletonService(TodoBloc())
    ..addSingletonService(TodoBloobit());

  return builder.toContainer();
}
