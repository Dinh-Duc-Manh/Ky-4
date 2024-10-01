import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/service/data.dart';
import '../model/Expenses.dart';

class ExpenseService {
  final Database db;

  ExpenseService(this.db);

  // Insert a new expense
  Future<void> insertExpense(Expenses expense) async {
    final db = await getDatabase();
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch expenses by trip_id
  Future<List<Expenses>> getByTripId(int tripId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'trip_id = ?',
      whereArgs: [tripId],
    );

    return List.generate(maps.length, (i) {
      return Expenses(
        maps[i]['expense_id'],
        maps[i]['trip_id'],
        maps[i]['expense_name'],
        maps[i]['expense_amount'],
        (maps[i]['expense_date'] != null ? DateTime.parse(maps[i]['expense_date']) : null) as int,
        maps[i]['expense_category'],
      );
    });
  }
}