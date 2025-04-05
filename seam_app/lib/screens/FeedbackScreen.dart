import 'package:flutter/material.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
 

  void _submitFeedback() async {
    String feedbackText = feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      try {
        await _firestore.collection('feedbacks').add({
          'feedback': feedbackText,
          'timestamp': FieldValue.serverTimestamp(),
          'user_id':"01",
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
    return Scaffold(
      appBar: AppBar(title: Text('Feedback Form'),centerTitle: true,),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child:Column(
        children: [
          //Dropdown for the feedback category
          DropdownButton<String>(
            value: selectCategory,
            hint: Text("Select Feedback category"),
            onChanged: (String? newValue){
              setState(() {
                selectCategory=newValue;
                //set the feedback category when selected 
                selectFeedback= sampleFeedbackText[selectCategory] ;
              });
            },
            items: feedbackCategories.map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
          SizedBox(height: 20,),

          if(selectFeedback != null)
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: selectFeedback!.map((feedback) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '• $feedback', // Add bullet points
                          style: TextStyle(fontSize: 16),
                        ),
                      )).toList(),
            ),
          ),
           SizedBox(height: 40,),
          Center(
            child: Text("Rating",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          //SizedBox(height: 10,),
          //star feedback animation
          AnimatedRatingStars(
            initialRating: 3.5,
            minRating: 0.0,
            maxRating: 5.0,
            filledColor: Colors.amber,
            emptyColor: Colors.grey,
            filledIcon: Icons.star,
            halfFilledIcon: Icons.star_half,
            emptyIcon: Icons.star_border,
            onChanged: (double rating) {
              // Handle the rating change here
              currentRating=rating;
              print('Rating: $rating');
            },
            displayRatingValue: true,
            interactiveTooltips: true,
            customFilledIcon: Icons.star,
            customHalfFilledIcon: Icons.star_half,
            customEmptyIcon: Icons.star_border,
            starSize: 30.0,
            animationDuration: Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
            readOnly: false,
            ),

            SizedBox(height: 20,),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write you feedback here ...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(onPressed: _submitFeedback
                
              , child: Text("Submit Feedback")),
            )
        ],
      )
      ),
      
    );
  }
}