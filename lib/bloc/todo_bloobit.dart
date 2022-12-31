import 'package:bloobit/bloobit.dart';
import 'package:my_todo_app/bloc/todo.dart';

class TodoBloobit extends Bloobit<TodoState> {
  TodoBloobit({super.onSetState})
      : super(TodoState(todos: [], isEditing: false));
  void addTodo(Todo todo) =>
      setState(state.copyWith(todos: state.todos..add(todo)));

  void deleteTodo(Todo todo) =>
      setState(state.copyWith(todos: state.todos..remove(todo)));

  void toggleTodo(Todo todo) {
    final todos = state.todos;
    final newTodos = todos
        .map((t) =>
            t == todo ? todo.copyWith(isCompleted: !todo.isCompleted) : t)
        .toList();
    setState(state.copyWith(todos: newTodos));
  }

  void toggleEditMode() =>
      setState(state.copyWith(isEditing: !state.isEditing));
}
