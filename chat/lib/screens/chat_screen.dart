import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:chat/themes/colors.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String avatar;
  final int conversationId;

  const ChatScreen(this.title, this.avatar, this.conversationId, {super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<dynamic> _messages = [];
  bool _loading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loading = true; // Set loading state to true when loading starts
    });
    final messages = await _apiService.getMessages(widget.conversationId);
    setState(() {
      _messages = messages;
      _loading = false; // Set loading state to false when loading finishes
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userId = await Auth.getUserId();
      await _apiService.sendMessage(
          userId, widget.conversationId, _controller.text);
      _controller.clear();
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> groupedMessages = {};
    for (var message in _messages) {
      String date =
          DateFormat('d MMMM').format(DateTime.parse(message['sent_at']));
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            Image(
              image: NetworkImage(
                  'https://khlex20.uztan.ga/chat/avatars/${widget.avatar}'),
              height: 35,
              width: 35,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: groupedMessages.length,
              itemBuilder: (ctx, index) {
                String date = groupedMessages.keys.elementAt(index);
                List<dynamic> messages = groupedMessages[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...messages.map((message) {
                      final isCurrentUser = message['username'] == widget.title;
                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(
                            maxWidth: 250,
                            minWidth: 115,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCurrentUser ? Colors.grey : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message_text'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isCurrentUser
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateFormat('HH:mm').format(
                                      DateTime.parse(message['sent_at'])),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isCurrentUser
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
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
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: buttonColor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
