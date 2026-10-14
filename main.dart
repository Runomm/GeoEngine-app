import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GeoEngineApp());
}

class GeoEngineApp extends StatelessWidget {
  const GeoEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoEngine Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _statusMessage = 'Ready';
  XFile? _selectedImage;
  String _jsonResponse = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    setState(() {
      _statusMessage = 'Selecting Image...';
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _selectedImage = pickedFile;
          _statusMessage = 'Ready (Image Selected)';
        } else {
          _statusMessage = 'Ready (Selection Cancelled)';
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error selecting image: $e';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      setState(() {
        _statusMessage = 'Error: No image selected';
      });
      return;
    }

    setState(() {
      _statusMessage = 'Processing...';
      _jsonResponse = '';
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8000/analyze'),
      );
      
      // Using readAsBytes() ensures cross-platform compatibility (Web & Mobile)
      final bytes = await _selectedImage!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file', 
          bytes,
          filename: _selectedImage!.name,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = 'Ready (Analysis Complete)';
          try {
             final dynamic parsedJson = jsonDecode(response.body);
             _jsonResponse = const JsonEncoder.withIndent('  ').convert(parsedJson);
          } catch (_) {
             _jsonResponse = response.body;
          }
        });
      } else {
        setState(() {
          _statusMessage = 'Error: Server responded with status ${response.statusCode}';
          _jsonResponse = response.body;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error connecting to server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoEngine OSINT'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: $_statusMessage',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _statusMessage == 'Processing...' ? null : _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick Image'),
                ),
                ElevatedButton.icon(
                  onPressed: (_selectedImage == null || _statusMessage == 'Processing...') 
                      ? null 
                      : _analyzeImage,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyze'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_statusMessage == 'Processing...')
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 12),
            const Text(
              'API Response:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _jsonResponse.isEmpty ? 'No data yet.' : _jsonResponse,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
