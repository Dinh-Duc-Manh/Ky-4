import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/Trips.dart';
import '../../../model/Tours.dart';
import '../../constants.dart';

class TripDetailScreen extends StatelessWidget {
  final Trips trip;
  final Tours tour;

  const TripDetailScreen({Key? key, required this.trip, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              _buildImageSection(tour.image),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripDetails(),
                    const SizedBox(height: 25),
                    Text(
                      trip.trip_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildTourSchedule(),
                    const SizedBox(height: 25),
                    _buildTripInfo(),
                    const SizedBox(height: 25),
                    _buildBudgetInfo(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Container(
      height: 200,
      width: double.infinity,
      child: imagePath.startsWith('/data/')
          ? Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      )
          : Image.asset(
        "assets/images/tours/$imagePath",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      ),
    );
  }

  Widget _buildTripDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.destination,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 14),
                const SizedBox(width: 5),
                Text(tour.nation, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '\$${trip.budget.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTourSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "Tour Schedule",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)
        ),
        const SizedBox(height: 10),
        _buildFormattedSchedule(tour.schedule),
      ],
    );
  }

  Widget _buildFormattedSchedule(String schedule) {
    final RegExp dayRegex = RegExp(r'DAY \d+:', caseSensitive: false);
    final List<TextSpan> textSpans = [];

    schedule.split('\n').forEach((line) {
      if (dayRegex.hasMatch(line)) {
        //
        if (textSpans.isNotEmpty) {
          textSpans.add(const TextSpan(text: '\n'));
        }
        textSpans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 17,
              height: 1.8),
        ));
      } else {
        textSpans.add(
            TextSpan(text: '$line\n', style: const TextStyle(height: 1.4)));
      }
    });

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: textSpans,
      ),
    );
  }

  Widget _buildTripInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "Trip Information",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)
        ),
        const SizedBox(height: 10),
        Text("Start Date: ${DateFormat.yMMMd().format(trip.start_date.toLocal())}",style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1.8) ),
        Text("End Date: ${DateFormat.yMMMd().format(trip.end_date.toLocal())}" ,style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1.8)),
        Text("Status: ${trip.status}",style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1.8)),
      ],
    );
  }

  Widget _buildBudgetInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "Budget Information",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)
        ),
        const SizedBox(height: 10),
        Text("Trip Budget: \$${trip.budget.toStringAsFixed(2)}",style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1.8)),
        Text("Tour Price: \$${tour.tour_price.toStringAsFixed(2)}",style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1.8)),
      ],
    );
  }
}