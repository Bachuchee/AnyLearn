import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NewTopicDialog extends StatefulWidget {
  const NewTopicDialog(this.onCreate, {super.key});

  final void Function(String newTopic) onCreate;

  @override
  State<NewTopicDialog> createState() => _NewTopicDialogState();
}

class _NewTopicDialogState extends State<NewTopicDialog> {
  late final TextEditingController _textController;
  bool _gotError = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "New Topic",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "topic",
                border: const OutlineInputBorder(),
                errorText: _gotError ? "Topic already exists!" : null,
              ),
              maxLength: 50,
              onChanged: (text) => setState(
                () {
                  _gotError = false;
                },
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _textController.text.isNotEmpty
                    ? () async {
                        final res = await PocketClient.createTopic(
                            _textController.text);
                        if (!res) {
                          widget.onCreate(_textController.text);
                          Navigator.pop(context);
                        }
                        setState(() {
                          _gotError = res;
                        });
                      }
                    : null,
                child: const Text("Submit"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
