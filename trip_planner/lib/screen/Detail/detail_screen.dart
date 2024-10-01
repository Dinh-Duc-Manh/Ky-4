import 'dart:io';

import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../model/Tours.dart';
import '../../model/Users.dart';
import 'Widget/detail_app_bar.dart';
import 'Widget/items_details.dart';
import 'Widget/trip.dart';

class DetailScreen extends StatelessWidget {
  final Users user;
  final Tours tour;

  const DetailScreen({super.key, required this.tour, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButton: Trip(tour: tour, user: user),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailAppBar(tour: tour),
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
                    ItemsDetails(tour: tour),
                    const SizedBox(height: 25),
                    Text(
                      tour.tour_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 25),
                    _buildTourSchedule(),
                    const SizedBox(height: 25),
                    _buildVisaInfo(),
                    const SizedBox(height: 25),
                    _buildGuideInfo(),
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

  Widget _buildTourSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tour program",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        _buildFormattedSchedule(tour.schedule),
      ],
    );
  }
  Widget _buildVisaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thông tin Visa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        const Text("- Quý khách chỉ cần hộ chiếu Việt Nam còn nguyên vẹn và có hạn sử dụng ít nhất 6 tháng tính từ ngày kết thúc tour.", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        const Text("- Miễn visa cho khách mang Quốc Tịch Việt Nam.", style: TextStyle(fontSize: 16)),
      ],
    );
  }
  Widget _buildGuideInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hướng dẫn viên", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        const Text("- Hướng Dẫn Viên (HDV) sẽ liên lạc với Quý Khách khoảng 2-3 ngày trước khi khởi hành.", style: TextStyle(fontSize: 16)),
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

  Widget _buildImageSection(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            child: imagePath.startsWith('/data/')
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/tours/${imagePath}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
