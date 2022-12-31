import 'package:bloobit/bloobit.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/bloc/todo_bloobit.dart';

class TodoListByBloobit extends StatefulWidget {
  const TodoListByBloobit({super.key});

  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoListByBloobit>
    with AttachesSetState<TodoListByBloobit, TodoBloobit> {
  @override
  Widget build(BuildContext context) => TodoListBloobit();
}

class TodoListBloobit extends StatelessWidget {
  const TodoListBloobit({super.key});

  @override
  Widget build(BuildContext context) {
    final todoBloobit = BloobitPropagator.of<TodoBloobit>(context).bloobit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todoBloobit.state.todos.length,
        itemBuilder: (context, index) {
          final todo = todoBloobit.state.todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: IconButton(
              icon: todo.isCompleted
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () => todoBloobit.toggleTodo(todo),
            ),
            onLongPress: () => todoBloobit.deleteTodo(todo),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoDialog(context, todoBloobit),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, TodoBloobit todoBloobit) {
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
                todoBloobit.addTodo(todo);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
