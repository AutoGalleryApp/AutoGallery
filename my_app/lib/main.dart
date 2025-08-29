// Flutter mobile app that picks an image from gallery and sends it to a desktop server

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
  } catch (e) {
    // Handle the case where .env file doesn't exist
    print('Error loading .env file: $e');
  }
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
  
  // State variables for settings (can override env vars)
  late String _serverHost;
  late String _serverPort;
  late bool _useHttps;
  
  @override
  void initState() {
    super.initState();
    // Initialize from environment variables with fallbacks
    _serverHost = dotenv.get('SERVER_HOST', fallback: '192.168.1.100');
    _serverPort = dotenv.get('SERVER_PORT', fallback: '8080');
    _useHttps = dotenv.get('USE_HTTPS', fallback: 'false').toLowerCase() == 'true';
  }
  
  // Generate server URL dynamically
  String get serverUrl {
    final protocol = _useHttps ? 'https' : 'http';
    return '$protocol://$_serverHost:$_serverPort/upload';
  }

  Future<void> pickAndSendImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('מעלה תמונה...')));

        var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
        request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));
        
        // Add timeout for better error handling
        final response = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Connection timeout - check server availability');
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('הועלה בהצלחה!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('שגיאה בהעלאה: ${response.statusCode}')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה: ${e.toString()}')));
    }
  }

  void _showServerSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('הגדרות שרת'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'כתובת שרת'),
                controller: TextEditingController(text: _serverHost),
                onChanged: (value) => _serverHost = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'פורט'),
                controller: TextEditingController(text: _serverPort),
                onChanged: (value) => _serverPort = value,
              ),
              CheckboxListTile(
                title: const Text('השתמש ב-HTTPS'),
                value: _useHttps,
                onChanged: (bool? value) {
                  setState(() {
                    _useHttps = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ביטול'),
            ),
            TextButton(
              onPressed: () {
                setState(() {}); // Refresh to update URL
                Navigator.of(context).pop();
              },
              child: const Text('שמור'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('שליחת תמונה'),
        actions: [
          IconButton(
            onPressed: _showServerSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'הגדרות שרת',
          ),
        ],
      ), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display current server URL
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'שרת: $serverUrl',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
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
