import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Complaintlist extends StatefulWidget {
  const Complaintlist({super.key});

  @override
  State<Complaintlist> createState() => _ComplaintlistState();
}

class _ComplaintlistState extends State<Complaintlist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> upvotedDocs = {};
  Map<String, bool> downvotedDocs = {};

  void updateVote(String docId, bool isUpvote) async {
    final docRef = _firestore.collection('complaints').doc(docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      int upvotes = (snapshot['upvote'] ?? 0) as int;
      int downvotes = (snapshot['downvote'] ?? 0) as int;

      bool hasUpvoted = upvotedDocs[docId] ?? false;
      bool hasDownvoted = downvotedDocs[docId] ?? false;

      int upvoteChange = 0;
      int downvoteChange = 0;

      if (isUpvote) {
        if (!hasUpvoted) {
          upvoteChange = 1;
          if (hasDownvoted) downvoteChange = -1;
        } else {
          upvoteChange = -1;
        }
        upvotedDocs[docId] = !hasUpvoted;
        downvotedDocs[docId] = false;
      } else {
        if (!hasDownvoted) {
          downvoteChange = 1;
          if (hasUpvoted) upvoteChange = -1;
        } else {
          downvoteChange = -1;
        }
        downvotedDocs[docId] = !hasDownvoted;
        upvotedDocs[docId] = false;
      }

      Map<String, dynamic> updateData = {};
      if (upvoteChange != 0) updateData['upvote'] = upvotes + upvoteChange;
      if (downvoteChange != 0)
        updateData['downvote'] = downvotes + downvoteChange;

      if (updateData.isNotEmpty) {
        transaction.update(docRef, updateData);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F9),
      appBar: AppBar(
        title: const Text(
          "Community Complaints",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2563EB),
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('complaints')
                .where('resolved', isEqualTo: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("All Complaints solved !!"));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("All Complaints solved !!"));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final docId = complaint.id;
              final data = complaint.data() as Map<String, dynamic>;

              final complaintText = data['complaint'] ?? 'No complaint text';
              final category = data['complaint_category'] ?? 'Unknown';
              final upvotes = (data['upvote'] ?? 0) as int;
              final downvotes = (data['downvote'] ?? 0) as int;
              final isSolved = data['solved'] ?? false;

              final hasUpvoted = upvotedDocs[docId] ?? false;
              final hasDownvoted = downvotedDocs[docId] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaintText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSolved
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSolved ? Colors.green : Colors.red,
                            ),
                          ),
                          child: Text(
                            isSolved ? 'Solved' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSolved ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => updateVote(docId, true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  hasUpvoted
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.grey.withOpacity(0.08),
                            ),
                            child: Icon(
                              Icons.thumb_up,
                              size: 20,
                              color: hasUpvoted ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$upvotes",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => updateVote(docId, false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  hasDownvoted
                                      ? Colors.red.withOpacity(0.15)
                                      : Colors.grey.withOpacity(0.08),
                            ),
                            child: Icon(
                              Icons.thumb_down,
                              size: 20,
                              color: hasDownvoted ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$downvotes",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
