import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/service/data.dart';
import '../model/Trips.dart';

class TripService {
  final Database db;

  TripService(this.db);

  // Insert a new trip
  Future<void> insertTrip(Trips trip) async {
    final db = await getDatabase();
    await db.insert(
      'trips',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all trips
  Future<List<Trips>> getAll() async {
    final List<Map<String, dynamic>> maps = await db.query('trips');

    return List.generate(maps.length, (i) {
      return Trips(
        maps[i]['trip_id'],
        maps[i]['trip_name'],
        DateTime.parse(maps[i]['start_date']),
        DateTime.parse(maps[i]['end_date']),
        maps[i]['destination'],
        maps[i]['total_price'],
        maps[i]['status'],
        maps[i]['tour_id'],
        maps[i]['user_id'],
      );
    });
  }

  Future<Trips> get(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'trip_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Trips(
        maps.first['trip_id'],
        maps.first['trip_name'],
        DateTime.parse(maps.first['start_date']),
        DateTime.parse(maps.first['end_date']),
        maps.first['destination'],
        maps.first['total_price'],
        maps.first['status'],
        maps.first['tour_id'],
        maps.first['user_id'],
      );
    } else {
      throw Exception('Trip not found');
    }
  }

  Future<int> update(Trips trip) async {
    return await db.update(
      'trips',
      trip.toMap(),
      where: 'trip_id = ?',
      whereArgs: [trip.trip_id],
    );
  }

  // Fetch trips by user_id
  Future<List<Trips>> getByUserId(int userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Trips(
        maps[i]['trip_id'],
        maps[i]['trip_name'],
        DateTime.parse(maps[i]['start_date']),
        DateTime.parse(maps[i]['end_date']),
        maps[i]['destination'],
        maps[i]['total_price'],
        maps[i]['status'],
        maps[i]['tour_id'],
        maps[i]['user_id'],
      );
    });
  }
}