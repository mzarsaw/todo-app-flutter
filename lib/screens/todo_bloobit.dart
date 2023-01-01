import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/bloc/todo_bloobit.dart';

class TodoListBloobit extends StatelessWidget {
  final TodoBloobit todoBloobit;
  const TodoListBloobit({super.key, required this.todoBloobit});

  @override
  Widget build(BuildContext context) {
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
        onPressed: () async => await todoBloobit.addTodo(),
      ),
    );
  }
}
