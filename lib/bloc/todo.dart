// The state for the todo app
import 'package:flutter/cupertino.dart';

class TodoState {
  List<Todo> todos;
  final bool isEditing;

  TodoState({
    required this.todos,
    required this.isEditing,
  });
  TodoState copyWith({List<Todo>? todos, bool? isEditing}) => TodoState(
      todos: todos ?? this.todos, isEditing: isEditing ?? this.isEditing);
}

// A single todo item
@immutable
class Todo {
  final String title;
  final bool isCompleted;

  const Todo({
    required this.title,
    required this.isCompleted,
  });
  Todo copyWith({String? title, bool? isCompleted}) => Todo(
      title: title ?? this.title, isCompleted: isCompleted ?? this.isCompleted);
}

// The events that can modify the todo app's state
@immutable
abstract class TodoEvent {
  final Todo todo;
  const TodoEvent({required this.todo});
}

@immutable
class AddTodo extends TodoEvent {
  const AddTodo({required super.todo});
}

@immutable
class DeleteTodo extends TodoEvent {
  const DeleteTodo({required super.todo});
}

@immutable
class ToggleTodo extends TodoEvent {
  const ToggleTodo({required super.todo});
}

@immutable
class ToggleEditMode extends TodoEvent {
  const ToggleEditMode({required super.todo});
}
