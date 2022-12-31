import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo.dart';

import '../bloc/todo_bloc_package.dart';

class TodoListBloc extends StatelessWidget {
  final IocContainer container;
  const TodoListBloc({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    final todoBloc = container.get<TodoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        bloc: todoBloc,
        builder: (context, state) {
          final todos = state.todos;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: IconButton(
                  icon: todo.isCompleted
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: () => todoBloc.add(ToggleTodo(todo: todo)),
                ),
                onLongPress: () => todoBloc.add(DeleteTodo(todo: todo)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoDialog(context, todoBloc),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, TodoBloc todoBloc) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: textController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final todo =
                    Todo(title: textController.text, isCompleted: false);
                todoBloc.add(AddTodo(todo: todo));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
