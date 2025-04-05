import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({Key? key}) : super(key: key);

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  String? _userName;
  
  // Modern color scheme
  final Color primaryColor = Color(0xFF2D3142);
  final Color accentColor = Color(0xFF4F6AF0);
  final Color backgroundColor = Color(0xFFF7F8FC);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF2D3142);
  final Color textLightColor = Color(0xFF9098B1);
  final Color dividerColor = Color(0xFFE5E9F2);
  final Color myMessageColor = Color(0xFF4F6AF0);
  final Color otherMessageColor = Color(0xFFF0F2F5);

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        final docSnapshot = await _firestore
            .collection('attendees')
            .where('email', isEqualTo: user.email)
            .get();
        
        if (docSnapshot.docs.isNotEmpty) {
          setState(() {
            _userName = docSnapshot.docs.first.data()['name'] as String?;
          });
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final user = _auth.currentUser;
    if (user == null) return;
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final messageRef = _database.ref().child('messages').push();
    
    messageRef.set({
      'text': _messageController.text.trim(),
      'senderId': user.uid,
      'senderName': _userName ?? 'Anonymous',
      'senderEmail': user.email,
      'timestamp': timestamp,
    });
    
    _messageController.clear();
    
    // Scroll to bottom after sending message
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Live Chat",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _database.ref().child('messages').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  );
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: accentColor),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: GoogleFonts.poppins(color: textLightColor),
                    ),
                  );
                }
                
                final messages = <Map<String, dynamic>>[];
                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                
                data.forEach((key, value) {
                  if (value is Map) {
                    messages.add({
                      'id': key,
                      ...Map<String, dynamic>.from(value),
                    });
                  }
                });
                
                // Sort messages by timestamp
                messages.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMyMessage = message['senderId'] == _auth.currentUser?.uid;
                    
                    return _buildMessageBubble(
                      message['text'] ?? '',
                      message['senderName'] ?? 'Anonymous',
                      message['timestamp'] ?? 0,
                      isMyMessage,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, String senderName, int timestamp, bool isMyMessage) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formattedTime = DateFormat('h:mm a').format(dateTime);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: accentColor.withOpacity(0.2),
              child: Text(
                senderName.isNotEmpty ? senderName[0].toUpperCase() : 'A',
                style: GoogleFonts.poppins(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMyMessage)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      senderName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textLightColor,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMyMessage ? myMessageColor : otherMessageColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      color: isMyMessage ? Colors.white : textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  formattedTime,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: textLightColor,
                  ),
                ),
              ],
            ),
          ),
          if (isMyMessage) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: accentColor,
              child: Text(
                senderName.isNotEmpty ? senderName[0].toUpperCase() : 'A',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.poppins(color: textLightColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: backgroundColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              style: GoogleFonts.poppins(color: textColor),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: accentColor,
            radius: 24,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
} 