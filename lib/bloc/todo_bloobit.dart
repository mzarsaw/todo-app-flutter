import 'package:bloobit/bloobit.dart';
import 'package:my_todo_app/bloc/todo.dart';
import 'package:my_todo_app/helpers/app_default.dart';
import 'package:my_todo_app/services/dialog_service.dart';

class TodoBloobit extends Bloobit<TodoState> {
  final IDialogService dialogService;
  TodoBloobit({required this.dialogService, super.onSetState})
      : super(TodoState(todos: [AppDefaults.testTodo], isEditing: false));
  Future addTodo() async {
    var title =
        await dialogService.showInputDialog(title: AppDefaults.dialogTitle);
    if (title != null) {
      setState(state.copyWith(
          todos: state.todos..add(Todo(title: title, isCompleted: false))));
    }
  }

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
