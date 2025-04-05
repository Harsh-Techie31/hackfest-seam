import 'package:flutter/material.dart';

class EmojiExpressionMeter extends StatefulWidget {
  final int score; // 0 to 100

  const EmojiExpressionMeter({super.key, required this.score});

  @override
  State<EmojiExpressionMeter> createState() => _EmojiExpressionMeterState();
}

class _EmojiExpressionMeterState extends State<EmojiExpressionMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.2,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void didUpdateWidget(covariant EmojiExpressionMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _controller.forward(); // Trigger bounce when score changes
    }
  }

  String getEmojiForScore(int score) {
    if (score >= 90) return "🥳";
    if (score >= 70) return "😄";
    if (score >= 50) return "😐";
    if (score >= 30) return "😟";
    if (score >= 10) return "😠";
    return "💀";
  }

  Color getColorForScore(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.lightGreen;
    if (score >= 50) return Colors.orange;
    if (score >= 30) return Colors.deepOrange;
    if (score >= 10) return Colors.red;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final emoji = getEmojiForScore(widget.score);
    final color = getColorForScore(widget.score);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Text(
            emoji,
            style: TextStyle(fontSize: 64),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Audience Score: ${widget.score}/100",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
