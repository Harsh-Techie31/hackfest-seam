import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> _uploadImageToCloudinary(File imageFile) async {
  final cloudName = 'dtj72cjug'; // replace with your Cloudinary cloud name
  final presetName = 'seam_lostandfound'; // e.g., flutter_unsigned

  final url = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
  );

  final request =
      http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = presetName
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final resStr = await response.stream.bytesToString();
    final data = json.decode(resStr);
    return data['secure_url']; // This is the image URL
  } else {
    print('Failed to upload image: ${response.statusCode}');
    return null;
  }
}

class LostAndFoundScreen extends StatefulWidget {
  @override
  _LostAndFoundScreenState createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  String _itemName = '';
  String _description = '';
  String _location = '';
  String _type = 'lost';
  File? _image;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImageToCloudinary(_image!);
      }

      await FirebaseFirestore.instance.collection('lost_found').add({
        'itemName': _itemName,
        'description': _description,
        'location': _location,
        'type': _type,
        'timestamp': FieldValue.serverTimestamp(),
        'phone_number': _phone,
        'imageUrl': imageUrl,
        'verified': true,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Report submitted successfully')));

      _formKey.currentState!.reset();
      setState(() {
        _image = null;
        _type = 'lost';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Lost & Found"),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [Tab(text: 'Report Item'), Tab(text: 'View Items')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _itemName = value!,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter item name'
                                      : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _description = value!,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter description'
                                      : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _location = value!,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter location'
                                      : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contact info (Phone number)',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _phone = value!,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter the phone number'
                                      : null,
                        ),
                        SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _type,
                          items: [
                            DropdownMenuItem(
                              value: 'lost',
                              child: Text('Lost'),
                            ),
                            DropdownMenuItem(
                              value: 'found',
                              child: Text('Found'),
                            ),
                          ],
                          onChanged: (val) => setState(() => _type = val!),
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          //icon: Icon(Icons.image_outlined),
                          label: Text(
                            "Pick Image (Optional)",
                            style: TextStyle(color: Colors.black87),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent.shade200,
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 5,
                            ),
                          ),
                          onPressed: _pickImage,
                        ),

                        if (_image != null)
                          Column(
                            children: [
                              SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Image selected",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              "No image selected",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            //icon: Icon(Icons.check_circle_outline),
                            label: Text(
                              "Submit",
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              backgroundColor: Colors.indigoAccent,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submitReport,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder(
            /*stream: FirebaseFirestore.instance
                .collection('lost_found').where('type',isEqualTo: 'lost').where('verified',isEqualTo: true)
                .orderBy('timestamp', descending: true)
                .snapshots(),*/
            stream:
                FirebaseFirestore.instance
                    .collection('lost_found')
                    .where('type', isEqualTo: 'lost')
                    .where('verified', isEqualTo: true)
                    .snapshots(),

            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text("No Data"));
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No items reported yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView(
                padding: EdgeInsets.all(12),
                children:
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                data['type'] == 'lost'
                                    ? Colors.red[200]
                                    : Colors.green[200],
                            child: Icon(
                              data['type'] == 'lost'
                                  ? Icons.warning
                                  : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            data['itemName'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(data['description'] ?? ''),
                              SizedBox(height: 2),
                              Text('📍 ${data['location'] ?? ''}'),
                              SizedBox(height: 2),
                              Text('📞 ${data['phone_number'] ?? ''}'),
                              SizedBox(height: 2),
                              Text(
                                'Type: ${data['type'] ?? ''}',
                                style: TextStyle(
                                  color:
                                      data['type'] == 'lost'
                                          ? Colors.red
                                          : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
