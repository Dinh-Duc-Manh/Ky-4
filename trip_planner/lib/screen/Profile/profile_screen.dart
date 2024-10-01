import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/Users.dart';
import '../Login/sign_in_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Users user;

  const ProfileScreen({super.key, required this.user});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user.user_id!),
      ),
    ).then((_) {
      ProfileScreen;
    });
  }

  ImageProvider _buildImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage("assets/images/users/$imagePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final TextStyle infoStyle = const TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _editProfile(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _buildImage(user.avatar),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _editProfile(context),
                  child: Text(
                    user.full_name,
                    style: titleStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text('Personal Information', style: titleStyle),
            const SizedBox(height: 16),
            Text('Email: ${user.email}', style: infoStyle),
            Text('Account Code: ${user.user_id}', style: infoStyle),
            Text('Account Status: ${user.status}', style: infoStyle),
            Text('Account Type: ${user.role}', style: infoStyle),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
