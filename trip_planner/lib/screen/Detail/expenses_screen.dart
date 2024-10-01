import 'package:flutter/material.dart';
import 'package:trip_planner/model/Expenses.dart';
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/model/Trips.dart';
import 'package:trip_planner/screen/Trip/trip_screen.dart';
import 'package:trip_planner/service/data.dart';
import 'package:trip_planner/service/expenses_service.dart';

import '../../model/Users.dart';
import '../nav_home_screen.dart';

class ExpensesScreen extends StatefulWidget {
  final Tours tour;
  final Users user;
  final Trips trip;
  final int amount; // Quantity
  final DateTime startDate; // Start date of the tour
  final DateTime endDate; // End date of the tour
  final double tourPrice; // Price of the tour

  const ExpensesScreen(
      {Key? key,
      required this.amount,
      required this.startDate,
      required this.endDate,
      required this.tourPrice,
      required this.tour,
      required this.trip,
      required this.user})
      : super(key: key);

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int duration = widget.endDate.difference(widget.startDate).inDays;
    double totalExpense = widget.tourPrice * widget.amount; // Total expense
    double dailyExpense =
        duration > 0 ? totalExpense / duration : 0; // Daily expense

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Expense per Day: \$${dailyExpense.toStringAsFixed(2)}'), // Changed label
            Text('Amount: ${widget.amount}'), // Display actual amount
            Text('Duration: $duration days'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Enter your feedback/notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Allow multiline feedback
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                placeOrder(context, dailyExpense);
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void placeOrder(BuildContext context, double dailyExpense) async {
    String notes = _notesController.text;

    // Use dailyExpense as expense_date in the string format for your model
    String expenseDate =
        dailyExpense.toStringAsFixed(2); // Keep it as a price format

    // Create an Expense object with the user's notes
    Expenses expense = Expenses(
      -1,
      widget.amount, // The amount or quantity
      expenseDate, // Use dailyExpense as expense_date
      notes, // User's notes
      widget.trip.trip_id, // Trip ID
      widget.user.user_id!, // Example user_id, replace with actual user_id
    );

    // Insert the expense into the database
    final db = await getDatabase();
    ExpenseService expenseService = ExpenseService(db);
    await expenseService.insertExpense(expense);

    // Print for debugging purposes
    print("Expense inserted: ${expense.toMap()}");

    // Navigate to the TripScreen after booking
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavHomeScreen(user: widget.user)),
    );
  }
}
