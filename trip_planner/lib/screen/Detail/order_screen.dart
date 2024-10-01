import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/model/Trips.dart';
import 'package:trip_planner/screen/Detail/expenses_screen.dart';
import 'package:trip_planner/service/data.dart';
import 'package:trip_planner/service/trip_service.dart';

import '../../model/Users.dart';

class OrderScreen extends StatefulWidget {
  final Users user;
  final Tours tour;
  final int quantity;  // Add the quantity parameter

  const OrderScreen({Key? key, required this.tour, required this.user, required this.quantity}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
        // Automatically calculate the end date based on the tour time
        _endDate = _startDate!.add(Duration(days: int.parse(widget.tour.time)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price based on the quantity
    double totalPrice = widget.tour.tour_price * widget.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tour.tour_name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display Destination (nation) from the tour
            Text(
              "Destination: ${widget.tour.nation}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text("Price per trip: \$${widget.tour.tour_price.toStringAsFixed(2)}"),
            const SizedBox(height: 20),

            // Start Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    _startDate == null
                        ? 'Select Start Date'
                        : 'Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // End Date Display (automatically calculated)
            Row(
              children: [
                Expanded(
                  child: Text(
                    _endDate == null
                        ? 'End Date: N/A'
                        : 'End Date: ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Price based on the number of trips selected
            Text(
              "Total Price: \$${totalPrice.toStringAsFixed(2)}",  // Format the price
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_startDate != null && _endDate != null) {
                  placeOrder();
                } else {
                  // Show an alert if the dates are not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a start date')),
                  );
                }
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void placeOrder() async {
    Trips trip = Trips(
      -1, // Auto-incrementing trip_id, so this will be ignored
      widget.tour.tour_name,
      _startDate!,
      _endDate!,
      widget.tour.nation,
      widget.tour.tour_price * widget.quantity, // Total price
      widget.tour.tour_id,
      widget.user.user_id!,
    );

    // Insert the trip into the database
    TripService service = TripService(await getDatabase());
    await service.insertTrip(trip);

    print("Trip booked: ${trip.toMap()}");

    // Pass start and end dates to ExpensesScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesScreen(
          tour: widget.tour,
          user: widget.user,
          trip: trip,
          amount: widget.quantity, // Pass the quantity as amount
          startDate: _startDate!,
          endDate: _endDate!,
          tourPrice: widget.tour.tour_price, // Pass the tour price
        ),
      ),
    );
  }
}
