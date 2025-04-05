import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seam_app/screens/BrandSelection.dart';
import 'package:seam_app/screens/FeedbackScreen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrandSelectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Event App",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
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
      body: Container(
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
      floatingActionButton: FloatingActionButton(
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
      ),
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
                  'John Doe',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'john.doe@example.com',
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
          _buildDrawerItem(Icons.search, 'Lost Items', _showLostItemsDialog),
          _buildDrawerItem(
            Icons.star,
            'Premium Membership',
            _showPremiumDialog,
          ),
          Divider(),
          _buildDrawerItem(Icons.logout, 'Logout', () {
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
          _buildQuickActions(),
          SizedBox(height: 24),
          _buildEventInfo(),
          SizedBox(height: 24),
          _buildAnnouncements(),
          SizedBox(height: 24),
          _buildSchedule(),
          SizedBox(height: 24),
          _buildSpeakers(),
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
            'Tech Conference 2024',
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
                'March 15-17, 2024',
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
    return Container(
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
                        fontSize: 14,
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildActionCard(
              icon: Icons.feedback,
              title: 'Feedback',
              onTap: _showFeedbackDialog,
            ),
            _buildActionCard(
              icon: Icons.report_problem,
              title: 'Complaints',
              onTap: _showComplaintDialog,
            ),
            _buildActionCard(
              icon: Icons.search,
              title: 'Lost Items',
              onTap: _showLostItemsDialog,
            ),
            _buildActionCard(
              icon: Icons.star,
              title: 'Premium',
              onTap: _showPremiumDialog,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: dividerColor, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accentColor, size: 32),
              SizedBox(height: 12),
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
            _buildInfoRow(Icons.calendar_today, 'Date', 'April 15, 2024'),
            _buildInfoRow(Icons.access_time, 'Time', '10:00 AM - 6:00 PM'),
            _buildInfoRow(Icons.location_on, 'Venue', 'Convention Center'),
            _buildInfoRow(Icons.confirmation_number, 'Ticket', '#12345'),
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

  Widget _buildAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Announcements',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildAnnouncementCard(
          'Welcome to the Event!',
          'We are excited to have you here. Please check the schedule for today\'s events.',
          DateTime.now(),
        ),
        SizedBox(height: 12),
        _buildAnnouncementCard(
          'Lunch Break',
          'Lunch will be served from 12:00 PM to 1:00 PM in the main hall.',
          DateTime.now().add(Duration(hours: 2)),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(String title, String message, DateTime time) {
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
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(message, style: GoogleFonts.poppins(color: textLightColor)),
            SizedBox(height: 8),
            Text(
              '${time.hour}:${time.minute}',
              style: GoogleFonts.poppins(color: textLightColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Today\'s Schedule',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
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
            children: [
              _buildScheduleItem(
                '9:00 AM',
                'Registration & Breakfast',
                'Main Hall',
              ),
              _buildScheduleDivider(),
              _buildScheduleItem('10:00 AM', 'Opening Ceremony', 'Main Hall'),
              _buildScheduleDivider(),
              _buildScheduleItem('11:30 AM', 'Keynote Speech', 'Main Hall'),
              _buildScheduleDivider(),
              _buildScheduleItem('1:00 PM', 'Lunch Break', 'Dining Hall'),
              _buildScheduleDivider(),
              _buildScheduleItem(
                '2:30 PM',
                'Workshop Sessions',
                'Various Rooms',
              ),
              _buildScheduleDivider(),
              _buildScheduleItem('4:00 PM', 'Networking Session', 'Lounge'),
              _buildScheduleDivider(),
              _buildScheduleItem('5:30 PM', 'Closing Ceremony', 'Main Hall'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(String time, String title, String location) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              time,
              style: GoogleFonts.poppins(color: textLightColor, fontSize: 14),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: textLightColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: textLightColor, size: 16),
        ],
      ),
    );
  }

  Widget _buildScheduleDivider() {
    return Divider(color: dividerColor, height: 1);
  }

  Widget _buildSpeakers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Speakers',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildSpeakerCard(
                'Dr. Sarah Johnson',
                'AI & Machine Learning',
                'assets/speaker1.jpg',
              ),
              _buildSpeakerCard(
                'John Smith',
                'Cloud Computing',
                'assets/speaker2.jpg',
              ),
              _buildSpeakerCard(
                'Emily Brown',
                'Cybersecurity',
                'assets/speaker3.jpg',
              ),
              _buildSpeakerCard(
                'Michael Chen',
                'Blockchain',
                'assets/speaker4.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerCard(String name, String topic, String imagePath) {
    return Container(
      width: 140,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: accentColor),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            topic,
            style: GoogleFonts.poppins(color: textLightColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Center(
      child: Text(
        'Chat with other attendees',
        style: GoogleFonts.poppins(fontSize: 16, color: textColor),
      ),
    );
  }

  Widget _buildFoodTab() {
    return Center(
      child: Text(
        'Order food and beverages',
        style: GoogleFonts.poppins(fontSize: 16, color: textColor),
      ),
    );
  }

  void _showFeedbackDialog() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Feedbackscreen()));
  }
  // void _showFeedbackDialog() {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           title: Text('Submit Feedback'),
  //           content: TextField(
  //             maxLines: 3,
  //             decoration: InputDecoration(
  //               hintText: 'Enter your feedback here...',
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('Cancel'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // TODO: Implement feedback submission
  //                 Navigator.pop(context);
  //               },
  //               child: Text('Submit'),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  void _showComplaintDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Submit a Complaint'),
            content: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your complaint here...',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement complaint submission
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showLostItemsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Report Lost Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Item Description'),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(hintText: 'Last Known Location'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement lost item report
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Premium Membership'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Get access to exclusive features:'),
                SizedBox(height: 16),
                _buildPremiumFeature(Icons.fastfood, 'Priority Food Ordering'),
                _buildPremiumFeature(Icons.chat, 'Direct Support Chat'),
                _buildPremiumFeature(Icons.star, 'Exclusive Event Updates'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Maybe Later'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement premium membership purchase
                  Navigator.pop(context);
                },
                child: Text('Upgrade Now'),
              ),
            ],
          ),
    );
  }

  Widget _buildPremiumFeature(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
