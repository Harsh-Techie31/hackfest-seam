import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/FetchingData.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/attendee-model.dart';

class EventLoginScreen extends StatefulWidget {
  const EventLoginScreen({super.key});
  @override
  EventLoginScreenState createState() => EventLoginScreenState();
}

class EventLoginScreenState extends State<EventLoginScreen> {
  final TextEditingController ticketIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController seatNumberController = TextEditingController();
  final TextEditingController entranceGateController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateTimeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  File? _ticketImage;
  bool _isLoading = false;
  final _missingFields = <String>{};

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _ticketImage = File(pickedFile.path);
        _isLoading = true;
        _missingFields.clear();
      });

      final bytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      final ticketData = await sendTicketForAnalysis(base64Image);

      setState(() {
        _isLoading = false;

        ticketIdController.text = ticketData!['ticketId'] ?? "";
        nameController.text = ticketData['name'] ?? "";
        seatNumberController.text = ticketData['seatNumber'] ?? "";
        entranceGateController.text = ticketData['entranceGate'] ?? "";
        contactInfoController.text = ticketData['contactInfo'] ?? "";
        eventNameController.text = ticketData['eventName'] ?? "";
        eventDateTimeController.text = ticketData['eventDateTime'] ?? "";

        _validateMandatoryFields();
      });
    }
  }

  void _validateMandatoryFields() {
    _missingFields.clear();
    if (ticketIdController.text.isEmpty) _missingFields.add("Ticket ID");
    if (nameController.text.isEmpty) _missingFields.add("Attendee Name");
    if (seatNumberController.text.isEmpty) _missingFields.add("Seat Number");
    if (entranceGateController.text.isEmpty) _missingFields.add("Entrance Gate");
    if (contactInfoController.text.isEmpty) _missingFields.add("Contact Number");
    if (emailController.text.isEmpty) _missingFields.add("Email");
    if (passwordController.text.isEmpty) _missingFields.add("Password");
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool required = false, bool isPassword = false}) {
    final hasError = _missingFields.contains(label);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: required ? "$label *" : label,
          labelStyle: GoogleFonts.poppins(
            color: hasError ? Colors.red : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    _validateMandatoryFields();

    setState(() {
      _isLoading = true;
    });

    if (_missingFields.isEmpty) {
      try {
        bool isNewUser = false;
        // Try to sign in first
        try {
          await _authService.signInWithEmailAndPassword(
            emailController.text,
            passwordController.text,
          );
          print("✅ User signed in successfully");
        } catch (e) {
          // If sign in fails, try to create a new account
          try {
            await _authService.signUpWithEmailAndPassword(
              emailController.text,
              passwordController.text,
            );
            isNewUser = true;
            print("✅ New account created and signed in successfully");
          } catch (e) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        // Create TicketInfo object with all the form data
        final ticketInfo = TicketInfo(
          ticketId: ticketIdController.text,
          attendeeName: nameController.text,
          seatNumber: seatNumberController.text,
          entranceGate: entranceGateController.text,
          contactNumber: contactInfoController.text,
          email: emailController.text,
          password: passwordController.text,
          eventName: eventNameController.text,
          eventDateTime: eventDateTimeController.text,
        );

        // Save data to Firestore
        try {
          await _firestoreService.saveAttendeeData(ticketInfo);
          print("✅ Data saved to Firestore successfully");
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isNewUser ? "Account created and data saved successfully!" : "Data updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // TODO: Navigate to next screen or handle success case
          
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to save data: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("❌ Missing mandatory fields");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields: ${_missingFields.join(", ")}"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Event Login", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (_ticketImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_ticketImage!, height: 180, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text("Scan Ticket"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.upload_file),
                      label: Text("Upload Ticket"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInputField("Ticket ID", ticketIdController, required: true),
                _buildInputField("Attendee Name", nameController, required: true),
                _buildInputField("Seat Number", seatNumberController, required: true),
                _buildInputField("Entrance Gate", entranceGateController, required: true),
                _buildInputField("Contact Number", contactInfoController, required: true),
                _buildInputField("Event Name", eventNameController),
                _buildInputField("Event Date & Time", eventDateTimeController),
                _buildInputField("Email", emailController, required: true),
                _buildInputField("Password", passwordController, required: true, isPassword: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("Submit", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.85),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFadingCube(
                      color: Colors.deepPurple,
                      size: 60.0,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Processing...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}