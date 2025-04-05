import 'package:flutter/material.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Feedbackscreen extends StatefulWidget {
  const Feedbackscreen({super.key});

  @override
  State<Feedbackscreen> createState() => _FeedbackscreenState();
}

class _FeedbackscreenState extends State<Feedbackscreen> {

  final List<String> feedbackCategories=[
    'Overall Event Experience',
    'Session-Specific Feedback',
    'Event staff & Volunteer',
    'Event Logistics',
    'Technichal Issues',
    'Safety & Security',
    'Sustainability & Eco-friendliness'
  ];

  Map<String,List<String>> sampleFeedbackText={
    'Overall Event Experience' : [
      'How well was the event organized?',
      'Was the event schedule clear and followed as planned?',
      'Did the event content meet your expectations?',
      'Were there enough opportunities to network?'
      ],
    'Session-Specific Feedback' :[
      'Was the session\'s audio and video quality adequate?',
      'Was the session too short, too long, or just right?',
      'Did the speaker encourage audience participation?',
    ],
    'Event staff & Volunteer':[
      'Rate the helpfulness of the event staff and volunteers.',
      'How friendly and approachable were the staff?',
      'How quickly were issues addressed by staff?'
    ],
    'Event Logistics':[
      'Was the registration process smooth and efficient?',
      'Were queues managed well (food, registration, etc.)?',
      ' Were signs and directions clear throughout the venue?'
    ],
    'Technichal Issues':[
      ' Was the event app responsive and functional?',
      ' Were there any issues with technical setups (e.g., audio ,video )?',
      'Are all electrical appliances (eg AC, fans) working properly?',
    ],
    'Safety & Security':[
      'Did you feel safe and secure at the venue?',
      'Was emergency information clearly communicated?',
      'How well did the security staff perform?',

    ],
    'Sustainability & Eco-friendliness':[
      'Did the event make efforts toward sustainability (e.g., waste management, eco-friendly materials)?,',
      'Was there an emphasis on minimizing the environmental footprint?',
    ],
  };

  String? selectCategory;
  List <String>? selectFeedback;
  double currentRating=3.5;
  TextEditingController feedbackController =TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
 

  void _submitFeedback() async {
    String feedbackText = feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      try {
        final  user=_auth.currentUser;
        await _firestore.collection('feedbacks').add({
          'feedback': feedbackText,
          'timestamp': FieldValue.serverTimestamp(),
          'user_id': user?.uid ?? 'anonymous',
          'category':selectCategory,
          'ratings':currentRating ,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $e')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectCategory,
                hint: Text(
                  "Choose a category",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectCategory = newValue;
                    selectFeedback = sampleFeedbackText[selectCategory];
                  });
                },
                items: feedbackCategories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            if (selectFeedback != null) ...[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feedback Points',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...selectFeedback!.map((feedback) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              feedback,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            Center(
              child: Text(
                "Your Rating",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedRatingStars(
                initialRating: 3.5,
                minRating: 0.0,
                maxRating: 5.0,
                filledColor: theme.primaryColor,
                emptyColor: Colors.grey,
                filledIcon: Icons.star,
                halfFilledIcon: Icons.star_half,
                emptyIcon: Icons.star_border,
                onChanged: (double rating) {
                  currentRating = rating;
                },
                displayRatingValue: true,
                interactiveTooltips: true,
                customFilledIcon: Icons.star,
                customHalfFilledIcon: Icons.star_half,
                customEmptyIcon: Icons.star_border,
                starSize: 32.0,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                readOnly: false,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Additional Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Share your thoughts here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
                filled: true,
                fillColor: theme.primaryColor.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Feedback",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}