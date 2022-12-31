import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/bloc/todo_stream.dart';

class TodoListStreamBuilder extends StatelessWidget {
  final IocContainer container;

  const TodoListStreamBuilder({super.key, required this.container});
  @override
  Widget build(BuildContext context) {
    final todoBloc = container.get<TodoStream>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: StreamBuilder(
        stream: todoBloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final state = snapshot.data as TodoState;
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
                  onPressed: () => todoBloc.event.add(ToggleTodo(todo: todo)),
                ),
                onLongPress: () => todoBloc.event.add(DeleteTodo(todo: todo)),
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

  void _showAddTodoDialog(BuildContext context, TodoStream todoBloc) {
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
                todoBloc.event.add(AddTodo(todo: todo));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
