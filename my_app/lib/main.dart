// Flutter mobile app that picks an image from gallery and sends it to a desktop server

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Sender',
      home: const ImageSenderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageSenderScreen extends StatefulWidget {
  const ImageSenderScreen({super.key});

  @override
  State<ImageSenderScreen> createState() => _ImageSenderScreenState();
}

class _ImageSenderScreenState extends State<ImageSenderScreen> {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // TODO: Replace with your computer's local IP address
  final String serverUrl = 'http://192.168.1.100:8080/upload';

  Future<void> pickAndSendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });

      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('הועלה בהצלחה!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('שגיאה בהעלאה')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('שליחת תמונה')), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickAndSendImage,
              child: const Text('בחר תמונה ושלח למחשב'),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.file(selectedImage!, height: 200),
              ),
          ],
        ),
      ),
    );
  }
}
