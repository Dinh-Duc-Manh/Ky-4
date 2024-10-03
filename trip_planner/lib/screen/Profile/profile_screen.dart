import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/Users.dart';
import '../Login/sign_in_screen.dart';
import '../Trip/trip_screen.dart';
import 'detail_profile_screen.dart';

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

  void _trip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripScreen(user: user),
      ),
    );
  }

  void _detailProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProfileScreen(user.user_id!),
      ),
    );
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _buildImage(user.avatar),
                ),
                const SizedBox(width: 16),
                Text(
                  user.full_name,
                  style: titleStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text('Personal Information', style: titleStyle),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _detailProfile(context),
              child: _buildRow('Thông tin người dùng', context),
            ),
            const SizedBox(height: 16),
            _buildRow('Lịch sử yêu thích', context),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _trip(context),
              child: _buildRow('Lịch sử đặt chuyến', context),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Phiên bản', style: infoStyle),
                const Spacer(), // This takes the remaining space
                Text('0.1', style: infoStyle),
              ],
            ),
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

  Widget _buildRow(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text('>', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
