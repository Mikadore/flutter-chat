import 'package:flutter/material.dart';
import '../chat.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.primary;
    return Row(
        mainAxisAlignment: message.author == null
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.author != null)
                    Text(
                      message.author!,
                      style:  TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: color),
                        color: color,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      message.content,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ))
        ]);
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Message> messages = [
    const Message(
      author: "Andie K.",
      content: "Abc",
    ),
    const Message(
      author: "Obi",
      content: "Hello there!",
    ),
    const Message(
      author: "Greavous",
      content: "General Kenobi?",
    ),
    const Message(
      author: "Obi",
      content: "AAAAAAAAAAAAAARGH",
    ),
  ];
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  _ChatViewState();

  void onMessage(String text) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      messages.add(Message(
        content: text,
      ));
    });
    _focus.requestFocus();
    _controller.clear();
  }

  @override
  Widget build(BuildContext ctx) {
    return Expanded(child: Container(
        color: Theme.of(ctx).primaryColor,
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView(
              children: messages.map((m) => MessageWidget(message: m)).toList(),
            )),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Press enter to chat!",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF424549),
                filled: true,
              ),
              onSubmitted: onMessage,
              focusNode: _focus,
              controller: _controller,
            )
          ],
        )));
  }
}