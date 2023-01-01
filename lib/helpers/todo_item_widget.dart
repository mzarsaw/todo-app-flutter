import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  const TodoItemWidget(
      {super.key, required this.todo, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(todo.title),
          trailing: IconButton(
            icon: todo.isCompleted
                ? const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )
                : const Icon(Icons.check_box_outline_blank),
            onPressed: onPressed,
          ),
          onLongPress: onLongPress,
        ),
      );
}
