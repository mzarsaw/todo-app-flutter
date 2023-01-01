import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/helpers/todo_item_widget.dart';

import '../bloc/todo_bloc_package.dart';

class TodoListBloc extends StatelessWidget {
  final IocContainer container;
  const TodoListBloc({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    final todoBloc = container<TodoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List using Bloc'),
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
