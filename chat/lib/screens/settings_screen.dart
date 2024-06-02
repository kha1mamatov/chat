import 'dart:io';
import 'package:chat/services/validator.dart';
import 'package:chat/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';

import 'package:path/path.dart' as path;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? _selectedAvatarFile;

  String avatar = "0.png";

  bool saveButton = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (saveButton)
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Done',
                style: TextStyle(color: linkColor),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _selectAvatar,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedAvatarFile != null
                    ? FileImage(_selectedAvatarFile!)
                    : NetworkImage("https://khlex20.uztan.ga/chat/avatars/$avatar") as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (change) {
                setState(() {
                  saveButton = true;
                });
              },
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (change) {
                setState(() {
                  saveButton = true;
                });
              },
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await Auth.logout();
                await Navigator.pushReplacementNamed(context, '/');
              },
              child: const Center(
                child: Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => changePass(context),
              child: const Text('Change password'),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchUserData() async {
    final info = await ApiService().getUserInfo(await Auth.getUserId());
    setState(() {
      avatar = info['avatar'] ?? '0';
      usernameController.text = info['username'];
      emailController.text = info['email'] ?? "";
    });
  }

  Future<void> _selectAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        saveButton = true;
        _selectedAvatarFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final validate = UsernameValidator().settings(usernameController.text, emailController.text);
    if (validate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validate)),
      );
    } else {
      if (_selectedAvatarFile != null) {
        await ApiService().uploadAvatarFile(_selectedAvatarFile!);
        await ApiService().saveUserInfoFull(
          (await Auth.getUserId()).toString(),
          usernameController.text,
          emailController.text,
          "${await Auth.getUserId()}${path.extension(_selectedAvatarFile!.path)}",
        );
      } else {
        await ApiService().saveUserInfo(
          (await Auth.getUserId()).toString(),
          usernameController.text,
          emailController.text,
        );
      }
      setState(() {
        saveButton = false;
      });
    }
  }

  void changePass(BuildContext context) {
    final TextEditingController password = TextEditingController();
    final TextEditingController password2 = TextEditingController();

    void save() {
      final validate = UsernameValidator.validatePassword(password.text, password2.text);
      if (validate != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validate)),
        );
      } else {
        ApiService().changePassword(Auth.getUserId().toString(), password.text);
        Navigator.of(context).pop(); // Close the dialog after saving
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Password'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(labelText: 'New password'),
                  ),
                  TextField(
                    controller: password2,
                    decoration: const InputDecoration(labelText: 'Confirm password'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: save,
                    child: const Center(
                      child: Text(
                        'Save new password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
