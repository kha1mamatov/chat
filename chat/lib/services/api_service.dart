import 'dart:convert';
import 'dart:io';
import 'package:chat/services/auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  late http.Client _client;

  set client(http.Client client) {
    _client = client;
  }

  final String baseUrl = 'https://khlex20.uztan.ga/chat';

  Future<Map<String, dynamic>> register(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> sendMessage(
      int userId, int conversationId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_message.php'),
      body: {
        'user_id': userId.toString(),
        'conversation_id': conversationId.toString(),
        'message': message,
      },
    );

    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getMessages(int conversationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_messages.php'),
      body: {
        'conversation_id': conversationId.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getChats(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_chats.php'),
      body: {
        'user_id': userId.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getUsers(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_all_users.php'),
      body: {
        'user_id': userId.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  Future<int> createChat(int userId1, int userId2) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_chat.php'),
      body: {
        'participants': jsonEncode([userId1, userId2]),
      },
    );
    return jsonDecode(response.body)['conversation_id'];
  }

  Future<Map> getUserInfo(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_info.php'),
      body: {
        'user_id': userId.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map> saveUserInfo(String userId, String username, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/set_user_info.php'),
      body: {
        'user_id': userId,
        'username': username,
        'email': email,
      },
    );
    return jsonDecode(response.body);
  }

  Future<void> uploadAvatarFile(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload_avatar.php'),
    );
    request.files.add(await http.MultipartFile.fromPath('avatar', file.path));
    request.fields['user_id'] = (await Auth.getUserId()).toString();

    await request.send();
  }

  Future<Map> saveUserInfoFull(
      String userId, String username, String email, String avatar) async {
    final response = await http.post(
      Uri.parse('$baseUrl/set_user_info_full.php'),
      body: {
        'user_id': userId,
        'username': username,
        'email': email,
        'avatar': avatar,
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map> changePassword(String userId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/set_password.php'),
      body: {
        'user_id': userId,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }
}
