import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database setup for the Tours and Trips models
Future<Database> getDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'trip_planner.db'),
    onCreate: (db, version) async {
//
      await db.execute('CREATE TABLE IF NOT EXISTS tours ('
          'tour_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'tour_name TEXT NOT NULL, '
          'image TEXT, '
          'time INTEGER, '
          'destination TEXT, '
          'schedule TEXT, '
          'nation TEXT, '
          'tour_price REAL NOT NULL '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS users ('
          'user_id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'avatar TEXT, '
          'user_name TEXT UNIQUE NOT NULL, '
          'email TEXT UNIQUE NOT NULL, '
          'password_hash TEXT NOT NULL, '
          'full_name TEXT, '
          'role TEXT DEFAULT "user", '
          'status TEXT DEFAULT "validity" '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS comments ('
          'comment_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'content TEXT,'
          'tour_id INTEGER,'
          'user_id INTEGER,'
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS trips ('
          'trip_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'trip_name TEXT,'
          'start_date TEXT,'
          'end_date TEXT,'
          'destination TEXT,'
          'total_price REAL,'
          'status TEXT DEFAULT "Waiting for confirmation",'
          'tour_id INTEGER,'
          'user_id INTEGER,'
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS expenses ('
          'expense_id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'trip_id INTEGER NOT NULL, '
          'user_id INTEGER NOT NULL, '
          'amount INTEGER NOT NULL, '
          'expense_date TEXT NOT NULL, '
          'notes TEXT, '
          'FOREIGN KEY(trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE, '
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS favorites ('
          'tour_id INTEGER, '
          'user_id INTEGER NOT NULL, '
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.insert('users', {
        'user_id': 1,
        'user_name': 'admin',
        'avatar': 'admin.jpg',
        'email': 'manhk5528@gmail.com',
        'password_hash': '123456',
        'full_name': 'Quản trị viên',
        'role': 'admin',
        'status': 'validity',
      });
      await db.insert('users', {
        'user_id': 2,
        'user_name': 'user1',
        'avatar': 'user1.jpg',
        'email': 'user1@gmail.com',
        'password_hash': '123456',
        'full_name': 'Người dùng 1',
        'role': 'user',
        'status': 'validity',
      });
      await db.insert('users', {
        'user_id': 3,
        'user_name': 'user2',
        'avatar': 'user2.jpg',
        'email': 'user2@gmail.com',
        'password_hash': '123456',
        'full_name': 'Người dùng 2',
        'role': 'user',
        'status': 'locked',
      });
// insert tours

    },
    version: 1,
  );
  return database;
}
