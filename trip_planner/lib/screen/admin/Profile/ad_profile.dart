import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/Users.dart';
import '../../Login/sign_in_screen.dart';

class AdProfile extends StatelessWidget {
  final Users user;

  const AdProfile({super.key, required this.user});

  void _logout(BuildContext context) {
    // Clear session data if necessary
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final TextStyle infoStyle = TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information Page'),
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
                  backgroundImage: AssetImage('assets/images/${user.avatar}'),
                ),
                SizedBox(width: 16),
                Text(
                  user.full_name,
                  style: titleStyle,
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text('Personal information', style: titleStyle),
            SizedBox(height: 16),
            Text('Email: ${user.email}', style: infoStyle),
            Text('Account code: ${user.user_id}', style: infoStyle),
            Text('Account Status: ${user.status}', style: infoStyle),
            Text('Account Type: ${user.role}', style: infoStyle),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
