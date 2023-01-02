import 'package:bloobit/bloobit.dart';
import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/state_managements/todo_bloobit.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/screens/todo_bloobit.dart';
import 'package:my_todo_app/screens/todo_flutter_bloc.dart';
import 'package:my_todo_app/screens/todo_stream_builder.dart';

const bloobitPropagatorKey = ValueKey('BloobitPropagator');

class HomePage extends StatelessWidget {
  final IocContainer container;
  const HomePage({super.key, required this.container});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppDefaults.appTitle),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text(AppDefaults.usingStream),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            container<TodoListStreamBuilderView>())),
              ),
              ElevatedButton(
                child: const Text(AppDefaults.usingBloc),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => container<TodoListBlocView>())),
              ),
              ElevatedButton(
                child: const Text(AppDefaults.usingBloobit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BloobitWidget(
                            bloobit: container.get<TodoBloobit>(),
                            builder: (context, bloobit) =>
                                container<TodoListBloobitView>()))),
              ),
            ],
          ),
        ),
      );
}
