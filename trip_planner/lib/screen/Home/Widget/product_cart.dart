import 'dart:io';

import 'package:flutter/material.dart';
import '../../../model/Tours.dart';
import '../../../model/Users.dart';
import '../../Detail/detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Users user;
  final Tours tour; // Replace with Tours model
  const ProductCard({super.key, required this.tour, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(tour: tour, user: user), // Pass tour to detail screen
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white, // Replace with your desired color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Hero(
                    tag: tour.image,
                    child: _buildTourImage(tour.image),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    tour.tour_name, // Use dynamic title from Tours
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${tour.tour_price} USD", // Use dynamic price from Tours
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      // If it's an asset image
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
      );
    }
  }
}
