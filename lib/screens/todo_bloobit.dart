import 'package:flutter/material.dart';
import 'package:my_todo_app/state_managements/todo_bloobit.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/helpers/todo_item_widget.dart';

class TodoListBloobitView extends StatelessWidget {
  final TodoBloobit todoBloobit;
  const TodoListBloobitView({super.key, required this.todoBloobit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('${AppDefaults.todoList} ${AppDefaults.usingBloobit}'),
      ),
      body: ListView.builder(
        itemCount: todoBloobit.state.todos.length,
        itemBuilder: (context, index) {
          final todo = todoBloobit.state.todos[index];
          return TodoItemWidget(
            todo: todo,
            onPressed: () => todoBloobit.toggleTodo(todo),
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
