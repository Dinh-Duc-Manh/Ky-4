import 'package:flutter/material.dart';
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/screen/Detail/detail_screen.dart';
import 'package:trip_planner/service/favorite_service.dart';
import '../../../model/Users.dart';

class FavoritesPage extends StatefulWidget {
  final Users user;

  const FavoritesPage({Key? key, required this.user}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Tours>> _favoriteTours;
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteTours();
  }

  void _loadFavoriteTours() {
    setState(() {
      _favoriteTours = _favoriteService.getFavoriteToursByUserId(widget.user.user_id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Tours'),
      ),
      body: FutureBuilder<List<Tours>>(
        future: _favoriteTours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite tours found.'));
          } else {
            final favoriteTours = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteTours.length,
              itemBuilder: (context, index) {
                final tour = favoriteTours[index];
                return ListTile(
                  leading: Image.asset(
                    "assets/images/tours/${tour.image}",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(tour.tour_name),
                  subtitle: Text("${tour.tour_price} USD"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(tour: tour, user: widget.user),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
