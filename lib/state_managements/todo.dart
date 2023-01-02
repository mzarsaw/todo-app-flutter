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
abstract class TodoEvent {}

@immutable
class AddTodo extends TodoEvent {}

@immutable
class DeleteTodo extends TodoEvent {
  final Todo todo;
  DeleteTodo({required this.todo});
}

@immutable
class ToggleTodo extends TodoEvent {
  final Todo todo;
  ToggleTodo({required this.todo});
}

@immutable
class ToggleEditMode extends TodoEvent {
  final Todo todo;
  ToggleEditMode({required this.todo});
}
