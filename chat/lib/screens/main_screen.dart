import 'package:flutter/material.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _chats = ["a"];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final userId = await Auth.getUserId();
      final response = await _apiService.getChats(userId);
      setState(() {
        _chats = response;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Chat App'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "/settings"),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadChats,
          child: _chats.isEmpty
              ? const Center(
                  child: Text("You haven't created any chats."),
                )
              : _chats[0] == 'a'
                  ? _buildShimmer()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _chats.length,
                            itemBuilder: (ctx, index) {
                              final chat = _chats[index];
                              final lastMessageTime =
                                  DateTime.parse(chat['last_message_time']);
                              final bool isToday =
                                  DateTime.now().day == lastMessageTime.day;
                              final displayTime = isToday
                                  ? DateFormat('HH:mm').format(lastMessageTime)
                                  : DateFormat('d MMMM')
                                      .format(lastMessageTime);
                              return ListTile(
                                leading: Image(
                                  image: NetworkImage(
                                      'https://khlex20.uztan.ga/chat/avatars/${chat["avatar"]}'),
                                  width: 35,
                                  height: 35,
                                ),
                                title:
                                    Text(chat['to_username'] ?? "Loading..."),
                                subtitle: Text(
                                    chat['last_message'] ?? "Send a message"),
                                trailing: Text(displayTime),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: [
                                      chat['to_username'],
                                      chat['avatar'],
                                      chat['conversation_id'],
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "/users"),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (ctx, index) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Color.fromARGB(66, 0, 0, 0), width: 1.0),
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(20, 224, 224, 224),
            highlightColor: const Color.fromARGB(255, 138, 138, 138),
            child: const SizedBox(
              width: double.infinity,
              height: 70,
            ),
          ),
        );
      },
    );
  }
}
