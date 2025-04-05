import 'package:feedback_app/Screens/MenuScreen.dart';
import 'package:flutter/material.dart';

class BrandSelectionScreen extends StatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
   final List<Map<String, dynamic>> brands = [
    {
      'name': 'KFC',
      'logo': 'assets/kfc.png',
      'menu': [
        {'name': 'Veg Zinger Burger', 'price': 120.0},
        {'name': 'Veg Fried Chicken', 'price': 150.0},
        {'name': 'Veg Fried Rice', 'price': 50.0},
        
      ]
    },
    {
      'name': 'McDonald\'s',
      'logo': 'assets/mcdonald.jpg',
      'menu': [
        {'name': 'McAloo Tikki', 'price': 50},
        {'name': 'McChicken', 'price': 100},
      ]
    },
    {
      'name': 'Burger King',
      'logo': 'assets/burgerking.png',
      'menu': [
        {'name': 'Whopper', 'price': 130},
        {'name': 'Fries', 'price': 60},
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Brand')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: brands.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MenuScreen(
                    brandName: brand['name'],
                    menuItems: brand['menu'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(brand['logo'], height: 80),
                  SizedBox(height: 8),
                  Text(brand['name'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}