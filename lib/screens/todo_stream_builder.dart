import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/bloc/todo_stream.dart';
import 'package:my_todo_app/helpers/todo_item_widget.dart';

class TodoListStreamBuilder extends StatelessWidget {
  final IocContainer container;

  const TodoListStreamBuilder({super.key, required this.container});
  @override
  Widget build(BuildContext context) {
    final todoBloc = container<TodoStream>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List using stream'),
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
              return TodoItemWidget(
                todo: todo,
                onPressed: () => todoBloc.event.add(ToggleTodo(todo: todo)),
                onLongPress: () => todoBloc.event.add(DeleteTodo(todo: todo)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => todoBloc.event.add(AddTodo()),
      ),
    );
  }
}
