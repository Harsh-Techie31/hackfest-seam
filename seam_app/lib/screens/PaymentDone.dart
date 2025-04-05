
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:seam_app/screens/BrandSelection.dart';

class PaymentSuccessScreen extends StatefulWidget {
  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Makes the tick blink

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Blinking Tick Animation
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 120,
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // Success Message
            Text(
              "Successful Payment Done",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Order Again with Us",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 40),

            // Order Again Button
            ElevatedButton(
              onPressed: () {
                // Add your action here
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BrandSelectionScreen()), 
                (route)=>false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Order Again",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            SizedBox(height: 20),

            // Thank You Message
            Text(
              "Thank You!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
