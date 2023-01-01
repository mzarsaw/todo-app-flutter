import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo_bloc_package.dart';
import 'package:my_todo_app/bloc/todo_bloobit.dart';
import 'package:my_todo_app/bloc/todo_stream.dart';
import 'package:my_todo_app/screens/home_page.dart';
import 'package:my_todo_app/services/dialog_service.dart';

void main() {
  runApp(MyApp(
    container: compose(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final IocContainer container;

  const MyApp({Key? key, required this.container}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
    ..add((container) =>
        TodoStream(dialogService: container.get<IDialogService>()))
    ..add(
        (container) => TodoBloc(dialogService: container.get<IDialogService>()))
    ..add((container) =>
        TodoBloobit(dialogService: container.get<IDialogService>()))
    ..add<IDialogService>((_) => DialogService(navigatorKey: navigatorKey));

  return builder.toContainer();
}
