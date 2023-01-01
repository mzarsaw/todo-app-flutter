import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/services/dialog_service.dart';

// The BLoC that manages the state and events for the todo app
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final IDialogService dialogService;
  TodoBloc({required this.dialogService})
      : super(
            TodoState(todos: <Todo>[AppDefaults.testTodo], isEditing: false)) {
    on<AddTodo>(_addTodo);
    on<DeleteTodo>((event, emit) =>
        emit(state.copyWith(todos: state.todos..remove(event.todo))));
    on<ToggleTodo>(_toggleTodo);
    on<ToggleEditMode>(
        (event, emit) => emit(state.copyWith(isEditing: !state.isEditing)));
  }
  Future _addTodo(AddTodo add, Emitter<TodoState> emit) async {
    var title =
        await dialogService.showInputDialog(title: AppDefaults.dialogTitle);
    if (title != null) {
      emit(state.copyWith(
          todos: state.todos..add(Todo(title: title, isCompleted: false))));
    }
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
