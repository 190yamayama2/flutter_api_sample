import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dialogs {
  final BuildContext context;

  Dialogs({required this.context});

  Future<void> showLoadingDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
              backgroundColor: Colors.black54,
              children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10,),
                      Text("お待ちください....", style: TextStyle(color: Colors.blueAccent),)
                    ]),
                  )
                ]
          );
        });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('アプリを終了します。よろしいですか？'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('はい'),
              onPressed: () => SystemNavigator.pop(),
            ),
            ElevatedButton(
              child: const Text('いいえ'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void closeDialog() {
    Navigator.pop(context);
  }

}