import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/FetchingData.dart';

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
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool required = false}) {
    final hasError = _missingFields.contains(label);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
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

  void _submitForm() {
    _validateMandatoryFields();

    setState(() {});

    if (_missingFields.isEmpty) {
      print("✅ Form submitted successfully");
    } else {
      print("❌ Missing mandatory fields");
    }
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
          "Analyzing Ticket...",
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