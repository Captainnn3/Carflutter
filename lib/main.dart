import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink Panther Vehicle Management',
      theme: ThemeData(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.pink,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const VehicleListScreen(),
    );
  }
}

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final CollectionReference vehicles =
      FirebaseFirestore.instance.collection('Vehicles');

  void _addOrEditVehicle({DocumentSnapshot? doc}) {
    final TextEditingController brandController =
        TextEditingController(text: doc != null ? doc['brand'] : '');
    final TextEditingController modelController =
        TextEditingController(text: doc != null ? doc['model'] : '');
    final TextEditingController yearController =
        TextEditingController(text: doc != null ? doc['year'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pink[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(doc == null ? 'Add Vehicle' : 'Edit Vehicle',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand', labelStyle: TextStyle(color: Colors.white)), style: TextStyle(color: Colors.white)),
              TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Model', labelStyle: TextStyle(color: Colors.white)), style: TextStyle(color: Colors.white)),
              TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Year', labelStyle: TextStyle(color: Colors.white)), style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (doc == null) {
                  vehicles.add({
                    'brand': brandController.text,
                    'model': modelController.text,
                    'year': yearController.text,
                  });
                } else {
                  vehicles.doc(doc.id).update({
                    'brand': brandController.text,
                    'model': modelController.text,
                    'year': yearController.text,
                  });
                }
                Navigator.pop(context);
              },
              child: Text(doc == null ? 'Add' : 'Save', style: TextStyle(color: Colors.pink)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(String id) {
    vehicles.doc(id).delete();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
      ),
      body: StreamBuilder(
        stream: vehicles.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Dismissible(
                key: Key(doc.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteVehicle(doc.id);
                },
                child: Card(
                  color: Colors.pink[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text('${doc['brand']} ${doc['model']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text('Year: ${doc['year']}',
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _addOrEditVehicle(doc: doc),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            _addOrEditVehicle();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        ],
      ),
    );
  }
}