
import 'package:flutter/material.dart';
// import 'package:slider_button/slider_button.dart';

class MenuScreen extends StatefulWidget {
  final String brandName;
  final List<Map<String, dynamic>> menuItems;

  MenuScreen({required this.brandName, required this.menuItems});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      // Check if item already exists in cart
      final existingItemIndex = cart.indexWhere((cartItem) => cartItem['name'] == item['name']);
      
      if (existingItemIndex >= 0) {
        // If exists, increase quantity
        cart[existingItemIndex]['quantity'] = (cart[existingItemIndex]['quantity'] ?? 1) + 1;
      } else {
        // If not exists, add with quantity 1
        cart.add({...item, 'quantity': 1});
      }
    });
  }

  double get totalItems {
    return cart.fold(0, (sum, item) => sum + (item['quantity'] ?? 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName} Menu'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Your Cart',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(16),
                            children: cart
                                .map((item) => ListTile(
                                      title: Text('${item['name']} (x${item['quantity']})'),
                                      trailing: Text("₹${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                                    ))
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Total: ₹${cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity'])).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10,),
                              // Center(
                              //   child: SliderButton(
                              //     action: () async{Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentSuccessScreen()),);},
                              //     label: Text("Proceed to pay",
                              //           style: TextStyle(
                              //             color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),),
                              //             icon: Text("yyy",
                              //             style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,
                              //             fontSize: 44),),
                              //   ),
                              // ),
                            ],
                          ),
                          
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      totalItems.toInt().toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.menuItems.length,
        itemBuilder: (context, index) {
          final item = widget.menuItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text("₹${item['price']}"),
            trailing: ElevatedButton(
              onPressed: () => addToCart(item),
              child: Text('Add'),
            ),
          );
        },
      ),
    );
  }
}