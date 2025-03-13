import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';
import '../screens/add_edit_restaurant_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(restaurant.category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditRestaurantScreen(restaurant: restaurant),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await firestoreService.deleteRestaurant(restaurant.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
