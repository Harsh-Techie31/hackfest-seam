import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>?> sendTicketForAnalysis(String base64Image) async {
  const String apiKey = 'AIzaSyCgOXBcy6IbE6xM5zdaw_R6IYxqNVpl11g';
  const String url =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey';

  final Map<String, dynamic> body = {
    "contents": [
      {
        "role": "user",
        "parts": [
          {
            "text":
                "Extract and return only the following 7 structured fields from this event ticket as pure JSON (not in Markdown format). If any field is not found on the ticket, set its value to null:ticketId,ticket holder name,seatNumber or entire seat name return as string for the entire seat info,entranceGate,contact number ,event name,eventDateTime, Return only these 7 fields in the JSON and nothing else. The output must be a clean, valid JSON object. Do not include any Markdown formatting or explanations. If a value is not available, set it to null."
          },
          {
            "inline_data": {
              "mime_type": "image/png",
              "data": base64Image
            }
          }
        ]
      }
    ]
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      String jsonString = decoded['candidates'][0]['content']['parts'][0]['text'];

      // Remove Markdown backticks and tags if present
      jsonString = jsonString.trim();
      if (jsonString.startsWith("```json")) {
        jsonString = jsonString.replaceAll(RegExp(r'^```json'), '');
        jsonString = jsonString.replaceAll(RegExp(r'```$'), '');
      }
      print(jsonDecode(jsonString));
      return jsonDecode(jsonString);
    } else {
      print('🔴 API Error ${response.statusCode}: ${response.body}');
      return null;
    }
  } catch (e) {
    print('❌ Exception: $e');
    return null;
  }
}
