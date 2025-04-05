import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seam_app/screens/ComplaintList.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();

}

class _ComplaintScreenState extends State<ComplaintScreen> {
List <String> ComplaintCategories=["Sound Issues", "Seating Problems", "Security Concern", "Other"];
String? selectedCategory;
TextEditingController submitComplaint= TextEditingController();
 List<Map<String,dynamic>> complaints = [];
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> _submitComplaint() async {
  String ComplaintText=submitComplaint.text.trim();
  if (ComplaintText.isNotEmpty) {
      try {
        await _firestore.collection('complaints').add({
          'complaint': ComplaintText,
          'timestamp': FieldValue.serverTimestamp(),
          'user_id':"01",
          'complaint_category':selectedCategory,
          'upvote':0,
          'downvote':0,
          'status':'Unsolved',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        submitComplaint.clear();
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
        "Complaint Portal",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.indigoAccent,
    ),
    backgroundColor: Colors.grey[100],
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Select Complaint Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    hint: Text("Choose a category"),
                    items: ComplaintCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: submitComplaint,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Describe your issue...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitComplaint,
                      //icon: Icon(Icons.send_rounded),
                      label: Text("Submit Complaint",style: TextStyle(color: Colors.black87),),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.indigoAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Complaintlist()),
              ),
              child: Text(
                "Track Your Complaint Status",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}