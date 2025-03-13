import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';

class FirestoreService {
  final CollectionReference _restaurantsCollection =
      FirebaseFirestore.instance.collection('Restaurants');

  // เพิ่มหรืออัปเดตร้านอาหาร
  Future<void> addOrUpdateRestaurant(Restaurant restaurant) async {
    await _restaurantsCollection.doc(restaurant.id).set(restaurant.toMap());
  }

  // ดึงข้อมูลร้านอาหารทั้งหมด
  Stream<List<Restaurant>> getRestaurants() {
    return _restaurantsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Restaurant.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // ลบร้านอาหาร
  Future<void> deleteRestaurant(String id) async {
    await _restaurantsCollection.doc(id).delete();
  }
}
