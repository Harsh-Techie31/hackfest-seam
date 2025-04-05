import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feedbackscreen extends StatefulWidget {
  const Feedbackscreen({super.key});

  @override
  State<Feedbackscreen> createState() => _FeedbackscreenState();
}

class _FeedbackscreenState extends State<Feedbackscreen> {
  // Modern color scheme
  final Color primaryColor = Color(0xFF2D3142);
  final Color accentColor = Color(0xFF4F6AF0);
  final Color backgroundColor = Color(0xFFF7F8FC);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF2D3142);
  final Color textLightColor = Color(0xFF9098B1);
  final Color dividerColor = Color(0xFFE5E9F2);

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Is the venue kid-friendly?',
      'answer': true,
    },
    {
      'question': 'Is the parking facility adequate?',
      'answer': true,
    },
    {
      'question': 'Is the venue wheelchair accessible?',
      'answer': true,
    },
    {
      'question': 'Are the restrooms clean and well-maintained?',
      'answer': true,
    },
    {
      'question': 'Is the venue well-lit and safe?',
      'answer': true,
    },
    {
      'question': 'Are there enough seating arrangements?',
      'answer': true,
    },
    {
      'question': 'Is the venue easily accessible by public transport?',
      'answer': true,
    },
    {
      'question': 'Is the venue suitable for large groups?',
      'answer': true,
    },
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSubmitting = false;

  void _updateAnswer(int index, bool value) {
    setState(() {
      questions[index]['answer'] = value;
    });
  }

  void _submitFeedback() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = _auth.currentUser;
      final Map<String, dynamic> feedbackData = {
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': user?.uid ?? 'anonymous',
        'user_email': user?.email ?? 'anonymous',
        'status': 'pending',
        'response': null,
      };

      // Add all questions and answers to the feedback data
      for (var i = 0; i < questions.length; i++) {
        feedbackData['q${i + 1}'] = {
          'question': questions[i]['question'],
          'answer': questions[i]['answer'],
        };
      }

      await _firestore.collection('feedbacks').add(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset all answers to true
      setState(() {
        for (var question in questions) {
          question['answer'] = true;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Venue Feedback',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please answer the following questions about the venue:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 24),
                ...questions.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Map<String, dynamic> question = entry.value;
                  return Column(
                    children: [
                      _buildQuestionCard(idx, question),
                      if (idx < questions.length - 1) SizedBox(height: 16),
                    ],
                  );
                }).toList(),
                SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnswerButton(
                    index,
                    true,
                    'Yes',
                    question['answer'] == true,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildAnswerButton(
                    index,
                    false,
                    'No',
                    question['answer'] == false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index, bool value, String label, bool isSelected) {
    return ElevatedButton(
      onPressed: () => _updateAnswer(index, value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? accentColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : textColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Submit Feedback',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}