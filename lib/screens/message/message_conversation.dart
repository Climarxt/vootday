import 'package:bootdv2/screens/message/appbar_title.dart';
import 'package:flutter/material.dart';

class MessageConversationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hello!', 'isSentByMe': true},
    {'text': 'Hi! How are you?', 'isSentByMe': false},
    {'text': 'I am good, thanks. And you?', 'isSentByMe': true},
    {'text': 'I am fine too.', 'isSentByMe': false},
  ];

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();

    return Scaffold(
      appBar: const AppBarTitle(title: "Conversation"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isSentByMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['isSentByMe']
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color:
                            message['isSentByMe'] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      // Ajoutez le message envoyé par l'utilisateur
                      messages.add({
                        'text': messageController.text,
                        'isSentByMe': true,
                      });

                      // Simulez une réponse
                      messages.add({
                        'text': 'Received: ${messageController.text}',
                        'isSentByMe': false,
                      });

                      // Effacez le champ de texte
                      messageController.clear();

                      // Réaffichez la liste des messages
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
