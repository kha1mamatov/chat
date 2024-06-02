import 'package:flutter/material.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _users = ["a"];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _apiService.getUsers(await Auth.getUserId());
    setState(() {
      _users = users;
    });
  }

  Future<void> _createChat(int userId, String avatar, String username) async {
    final conversationId =
        await _apiService.createChat(await Auth.getUserId(), userId);
    Navigator.pushNamed(
      context,
      "/chat",
      arguments: [
        username,
        avatar,
        conversationId,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All users'),
      ),
      body: _users.isEmpty
          ? const Center(
              child: Text("There is no available users left."),
            )
          : _users[0] == "a"
              ? const Center(
                  child: Text("Loading..."),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = _users[index];
                    return ListTile(
                      leading: Image(
                        image: NetworkImage(
                            'https://khlex20.uztan.ga/chat/avatars/${user["avatar"]}'),
                        height: 35,
                        width: 35,
                      ),
                      title: Text(user['username']),
                      onTap: () {
                        _createChat(
                          user['user_id'],
                          user['avatar'],
                          user['username'],
                        );
                      },
                    );
                  },
                ),
    );
  }
}
