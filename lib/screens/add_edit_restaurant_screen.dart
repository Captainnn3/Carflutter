import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/restaurant.dart';

class AddEditRestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  const AddEditRestaurantScreen({super.key, this.restaurant});

  @override
  _AddEditRestaurantScreenState createState() =>
      _AddEditRestaurantScreenState();
}

class _AddEditRestaurantScreenState extends State<AddEditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.restaurant != null) {
      _nameController.text = widget.restaurant!.name;
      _categoryController.text = widget.restaurant!.category;
      _locationController.text = widget.restaurant!.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant == null ? 'เพิ่มร้านอาหาร' : 'แก้ไขร้านอาหาร'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อร้านอาหาร'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อร้าน' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'ประเภทอาหาร'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกประเภทอาหาร' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'ที่ตั้งร้าน'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกที่ตั้งร้าน' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.restaurant == null ? 'เพิ่มร้าน' : 'อัปเดตร้าน'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final restaurant = Restaurant(
                      id: widget.restaurant?.id ?? DateTime.now().toString(),
                      name: _nameController.text,
                      category: _categoryController.text,
                      location: _locationController.text,
                    );

                    await firestoreService.addOrUpdateRestaurant(restaurant);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
