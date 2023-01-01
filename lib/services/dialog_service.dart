import 'package:flutter/material.dart';
import 'package:my_todo_app/helpers/app_default.dart';

abstract class IDialogService {
  Future<String?> showInputDialog(
      {VoidCallback? onAdd, VoidCallback? onCancel, String? title});
}

class DialogService implements IDialogService {
  final GlobalKey<NavigatorState> navigatorKey;
  DialogService({required this.navigatorKey});
  @override
  Future<String?> showInputDialog(
      {VoidCallback? onAdd, VoidCallback? onCancel, String? title}) {
    title = title ?? AppDefaults.dialogTitle;
    return showDialog<String?>(
      context: navigatorKey.currentState!.context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: Text(title!),
          content: TextField(
            controller: textController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (onCancel != null) {
                  onCancel();
                }
                Navigator.pop<String?>(context);
              },
              child: const Text(AppDefaults.cancel),
            ),
            TextButton(
              onPressed: () {
                if (onAdd != null) {
                  onAdd();
                }
                Navigator.pop<String?>(context, textController.text);
              },
              child: const Text(AppDefaults.add),
            ),
          ],
        );
      },
    );
  }
}
