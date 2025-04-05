import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seam_app/screens/BrandSelection.dart';
import 'package:seam_app/screens/ComplaintList.dart';
import 'package:seam_app/screens/ComplaintScreen.dart';
import 'package:seam_app/screens/FeedbackScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seam_app/screens/LostScreen.dart';
import 'package:seam_app/services/firestore_service.dart';
import 'package:seam_app/models/attendee-model.dart';
import 'package:seam_app/widget/emojindicator.dart';
import 'chatbot_screen.dart';
import 'LiveChatScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isLoading = true;
  TicketInfo? _attendeeData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  int audienceScore = 50; // starting score

  // Modern color scheme
  final Color primaryColor = Color(0xFF2D3142);
  final Color accentColor = Color(0xFF4F6AF0);
  final Color backgroundColor = Color(0xFFF7F8FC);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF2D3142);
  final Color textLightColor = Color(0xFF9098B1);
  final Color dividerColor = Color(0xFFE5E9F2);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAttendeeData();
  }

  Future<void> _loadAttendeeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final attendeeData = await _firestoreService.getAttendeeData(
          user.email!,
        );
        setState(() {
          _attendeeData = attendeeData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading attendee data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "EventGaurdian",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body:
          _isLoading
              ? Center(
                child: SpinKitDoubleBounce(color: accentColor, size: 50.0),
              )
              : Container(
                decoration: BoxDecoration(color: backgroundColor),
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildHomeTab(), _buildChatTab(), _buildFoodTab()],
                ),
              ),
      bottomNavigationBar: Container(
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
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined),
              activeIcon: Icon(Icons.restaurant),
              label: 'Food',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: accentColor,
          unselectedItemColor: textLightColor,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                backgroundColor: accentColor,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ChatbotScreen(),
                  );
                },
                child: Icon(Icons.chat_bubble_outline, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  _attendeeData?.attendeeName ?? 'Guest User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _attendeeData?.email ?? 'guest@example.com',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.feedback, 'Feedback', _showFeedbackDialog),
          _buildDrawerItem(
            Icons.report_problem,
            'Complaints',
            _showComplaintDialog,
          ),
          _buildDrawerItem(Icons.restaurant, 'Order Food', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BrandSelectionScreen()),
            );
          }),
          _buildDrawerItem(Icons.chat, 'Live Chat', () {
            // TODO: Implement live chat
          }),
          Divider(),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            _auth.signOut();
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          _buildHeroSection(),
          SizedBox(height: 24),
          _buildUpcomingEvents(),
        
          SizedBox(height: 24),
          // SizedBox(height: 24),
          _buildQuickActions(),
          SizedBox(height: 24),
          _buildEventInfo(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to',
            style: GoogleFonts.poppins(color: textLightColor, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            _attendeeData?.eventName ?? 'Event',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, color: accentColor, size: 16),
              SizedBox(width: 8),
              Text(
                _attendeeData?.eventDateTime ?? 'Date not specified',
                style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Upcoming Events',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildEventCard(
                'Keynote Speech',
                '9:00 AM',
                'Main Hall',
                Icons.mic,
                accentColor,
              ),
              _buildEventCard(
                'Workshop',
                '11:00 AM',
                'Room 101',
                Icons.computer,
                Color(0xFF4CAF50),
              ),
              _buildEventCard(
                'Networking',
                '1:00 PM',
                'Lounge',
                Icons.people,
                Color(0xFFFF9800),
              ),
              _buildEventCard(
                'Panel Discussion',
                '3:00 PM',
                'Conference Room',
                Icons.forum,
                Color(0xFF9C27B0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String title,
    String time,
    String location,
    IconData icon,
    Color color,
  ) {
    return Flexible(
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(icon, size: 100, color: color.withOpacity(0.1)),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: textLightColor, size: 16),
                      SizedBox(width: 8),
                      Text(
                        time,
                        style: GoogleFonts.poppins(
                          color: textLightColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: textLightColor, size: 16),
                      SizedBox(width: 8),
                      Text(
                        location,
                        style: GoogleFonts.poppins(
                          color: textLightColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Add to Calendar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          padding: EdgeInsets.symmetric(horizontal: 16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildActionCard(
              'Submit Feedback',
              Icons.feedback,
              accentColor,
              _showFeedbackDialog,
            ),
            _buildActionCard(
              'File Complaint',
              Icons.report_problem,
              Color(0xFFF44336),
              _showComplaintDialog,
            ),
            _buildActionCard(
              'Live Complaints',
              Icons.support_agent,
              Color(0xFFEF5350),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Complaintlist(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Lost & Found',
              Icons.find_in_page,
            Color(0xFF6A1B9A),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LostAndFoundScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Order Food',
              Icons.local_restaurant_outlined,
              Color(0xFF4CAF50),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandSelectionScreen(),
                  ),
                );
              },
            ),
            _buildActionCard('Live Chat', Icons.chat, Color(0xFFFF9800), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveChatScreen(),
                  ),
                );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Information',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              _attendeeData?.eventDateTime ?? 'Not specified',
            ),
            _buildInfoRow(Icons.access_time, 'Time', '10:00 AM - 6:00 PM'),
            _buildInfoRow(Icons.location_on, 'Venue', 'Convention Center'),
            _buildInfoRow(
              Icons.confirmation_number,
              'Ticket',
              _attendeeData?.ticketId ?? 'Not specified',
            ),
            _buildInfoRow(
              Icons.chair,
              'Seat',
              _attendeeData?.seatNumber ?? 'Not specified',
            ),
            _buildInfoRow(
              Icons.door_front_door,
              'Entrance',
              _attendeeData?.entranceGate ?? 'Not specified',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Text(value, style: GoogleFonts.poppins(color: textLightColor)),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return LiveChatScreen();
  }

  Widget _buildFoodTab() {
    return BrandSelectionScreen();
  }

  void _showFeedbackDialog() {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Feedbackscreen()),
    );
  }

  void _showComplaintDialog() {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComplaintScreen()),
    );
  }
}
