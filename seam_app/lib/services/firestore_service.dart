import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendee-model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save attendee data to Firestore
  Future<void> saveAttendeeData(TicketInfo ticketInfo) async {
    try {
      // Create a document with the user's email as the ID
      await _firestore.collection('attendees').doc(ticketInfo.email).set({
        'ticketId': ticketInfo.ticketId,
        'name': ticketInfo.attendeeName,
        'seatNumber': ticketInfo.seatNumber,
        'entranceGate': ticketInfo.entranceGate,
        'contactNumber': ticketInfo.contactNumber,
        'email': ticketInfo.email,
        'eventName': ticketInfo.eventName,
        'eventDateTime': ticketInfo.eventDateTime,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to save attendee data: $e';
    }
  }

  // Get attendee data from Firestore
  Future<TicketInfo?> getAttendeeData(String email) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('attendees').doc(email).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TicketInfo(
          ticketId: data['ticketId'] ?? '',
          attendeeName: data['name'] ?? '',
          seatNumber: data['seatNumber'] ?? '',
          entranceGate: data['entranceGate'] ?? '',
          contactNumber: data['contactInfo'] ?? '',
          email: data['email'] ?? '',
          password: '', // We don't store passwords in Firestore
          eventName: data['eventName'],
          eventDateTime: data['eventDateTime'],
        );
      }
      return null;
    } catch (e) {
      throw 'Failed to get attendee data: $e';
    }
  }
} 