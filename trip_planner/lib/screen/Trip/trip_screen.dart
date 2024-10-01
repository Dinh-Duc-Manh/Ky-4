import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/Tours.dart';
import '../../../model/Trips.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';
import '../../../service/trip_service.dart';
import '../../model/Users.dart';

class TripScreen extends StatefulWidget {
  final Users user;

  const TripScreen({super.key, required this.user});

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  List<Trips> trips = [];
  late TripService tripService;
  List<Tours> tours = [];
  late TourService tourService;

  Future<void> getTrips() async {
    try {
      tripService = TripService(await getDatabase());
      var data = await tripService.getByUserId(widget.user.user_id!);
      setState(() {
        trips = data;
      });
    } catch (e) {
      print("Error getting trips: $e");
    }
  }

  Future<void> getTours() async {
    try {
      tourService = TourService(await getDatabase());
      var data = await tourService.getAll();
      setState(() {
        tours = data;
      });
    } catch (e) {
      print("Error getting tours: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getTrips();
    getTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips for ${widget.user.full_name}'),
      ),
      body: trips.isEmpty
          ? Center(child: Text('No trips found for this user.'))
          : ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          final tour = tours.firstWhere(
                (t) => t.tour_id == trip.tour_id,
          );
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Container(
                width: 80,
                height: 80,
                child: _buildTripImage(tour.image),
              ),
              title: Text(
                trip.trip_name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip code: ${trip.trip_id}'),
                  Text('Trip Price: ${trip.budget.toStringAsFixed(2)} USD'),
                  Text('Start time: ${DateFormat.yMMMd().format(trip.start_date.toLocal())}'),
                  Text('End time: ${DateFormat.yMMMd().format(trip.end_date.toLocal())}'),
                  Text('Destination: ${trip.destination}'),
                ],
              ),
              onTap: () {
                // You can navigate to a detail page if needed
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return Image.asset(
        "assets/images/tours/$imagePath",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image_not_supported);
        },
      );
    }
  }
}