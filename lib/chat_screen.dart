import 'package:flutter/material.dart';
import 'services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vibe Chat 💬")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService.getMessages(widget.roomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index]['text'];
                    final user = messages[index]['user'];
                    return ListTile(
                      title: Text(msg),
                      subtitle: Text(user),
                    );
                  },
                );
              },
            ),
          ),

          // INPUT FIELD
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        InputDecoration(hintText: "Type message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    ChatService.sendMessage(
                        widget.roomId, messageController.text);
                    messageController.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}