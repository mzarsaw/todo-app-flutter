import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/bloc/todo.dart';

// The BLoC that manages the state and events for the todo app
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc()
      : super(TodoState(
            todos: <Todo>[const Todo(title: 'test', isCompleted: true)],
            isEditing: false)) {
    on<AddTodo>((event, emit) =>
        emit(state.copyWith(todos: state.todos..add(event.todo))));
    on<DeleteTodo>((event, emit) =>
        emit(state.copyWith(todos: state.todos..remove(event.todo))));
    on<ToggleTodo>(_toggleTodo);
    on<ToggleEditMode>(
        (event, emit) => emit(state.copyWith(isEditing: !state.isEditing)));
  }
  void _toggleTodo(ToggleTodo toggleTodo, Emitter<TodoState> emit) {
    final newTodos = state.todos
        .map((t) => t == toggleTodo.todo
            ? Todo(title: t.title, isCompleted: !t.isCompleted)
            : t)
        .toList();
    emit(state.copyWith(todos: newTodos));
  }
}
