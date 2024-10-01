import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/Users.dart';
import '../../../service/User_Service.dart';
import '../../../service/data.dart';

class DetailAccountScreen extends StatefulWidget {
  final int id;
  DetailAccountScreen(this.id);

  @override
  _DetailAccountScreenState createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  late UserService service;
  Users user = Users(
    user_id: 0,
    full_name: "",
    avatar: "",
    user_name: "",
    password_hash: "",
    email: "",
    role: "",
    status: "",
  ); // Initialize with default values

  getUser() async {
    service = UserService(await getDatabase());
    var data = await service.getById(widget.id);
    setState(() {
      user = data ?? user; // Use default if not found
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: _buildImage(user.avatar),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("User details"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User code: ${user.user_id}'),
            SizedBox(height: 15),
            Text('Full name: ${user.full_name}'),
            SizedBox(height: 15),
            Text('User name: ${user.user_name}'),
            SizedBox(height: 15),
            Text('User email: ${user.email}'),
            SizedBox(height: 15),
            Text('Account Type: ${user.role}'),
            SizedBox(height: 15),
            Text('Account Status: ${user.status}'),
            SizedBox(height: 15),
            if (user.avatar.isNotEmpty) ...[
              Text('Avatar:'),
              SizedBox(height: 10),
              _buildAvatar(),
            ],
          ],
        ),
      ),
    );
  }
}
