
// with reduced box size and common bg
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';  // mobile
import 'package:flutter/foundation.dart';  // for kIsWeb check
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMobileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );
  }

  Future<void> _startRecording() async {
    if (!kIsWeb && await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder?.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
     body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF006A68), Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: SingleChildScrollView( // FIX: Allows scrolling when overflow happens
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures proper alignment
        children: [
          _imageFile != null
              ? Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover)
              : const Text('No image selected.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: kIsWeb ? () {} : _pickMobileImage,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF057962)),
            child: const Text('Upload Image'),
          ),
          const SizedBox(height: 20),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 40, // Minimum height
                maxHeight: 120, // Limit height to avoid overflow
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: null, // Auto-adjust height
                decoration: const InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Upload Data'),
          ),
        ],
      ),
    ),
  ),
),

      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}


/*

//dynamic size  box but missing recorder
import 'package:flutter/material.dart'; 
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMobileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006A68), Colors.white, Color(0xFFB0B0B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover),
                    )
                  : const Text('No image selected.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: kIsWeb ? () {} : _pickMobileImage,
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text('Upload Image', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF057962),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 150,
                  ),
                  child: Scrollbar(
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Enter Description',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Upload Data', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'undo',
            onPressed: _hasSaved ? () {} : null,
            backgroundColor: _hasSaved ? Colors.blue : Colors.grey,
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'skip',
            onPressed: () {},
            backgroundColor: Colors.orange,
            child: const Icon(Icons.skip_next),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'save',
            onPressed: () {},
            backgroundColor: Colors.green,
            child: const Icon(Icons.save),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
*/
// missingrecorder
/*

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMobileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006A68), Colors.white, Color(0xFFB0B0B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover),
                    )
                  : const Text('No image selected.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: kIsWeb ? () {} : _pickMobileImage,
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text('Upload Image', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF057962),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Upload Data', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'undo',
            onPressed: _hasSaved ? () {} : null,
            backgroundColor: _hasSaved ? Colors.blue : Colors.grey,
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'skip',
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 159, 131, 90),
            child: const Icon(Icons.skip_next),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'save',
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 142, 147, 153),
            child: const Icon(Icons.save),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
*/
//code with recorder and LKG background
/*
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';  // mobile
import 'package:flutter/foundation.dart';  // for kIsWeb check
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  // Image picker for mobile platforms
  Future<void> _pickMobileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Function for uploading data
  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );

    // Add upload logic here (Firebase or server API call)
  }

  // Recording start/stop
  Future<void> _startRecording() async {
    if (!kIsWeb && await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder?.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover)
                : const Text('No image selected.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: kIsWeb ? () {} : _pickMobileImage, // _pickMobileImage is used on mobile platforms
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF057962)),
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Upload Data'),
            ),
            const SizedBox(height: 20),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
*/


/*
//updated with pick mob image,we img both
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickWebImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _webImage = bytesFromPicker;
        _imageFile = null;
      });
    }
  }

  Future<void> _pickMobileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _webImage = null; // Clear web image if picking mobile image
      });
    }
  }

  Future<void> _startRecording() async {
    if (!kIsWeb && await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder?.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );

    // Add upload logic here (Firebase or server API call)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover)
                : _webImage != null
                    ? Image.memory(_webImage!, width: 200, height: 200, fit: BoxFit.cover)
                    : const Text('No image selected.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: kIsWeb ? _pickWebImage : _pickMobileImage,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF057962)),
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Upload Data'),
            ),
            const SizedBox(height: 20),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
*/

/*
// upload_page.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'bottom_nav.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickWebImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _webImage = bytesFromPicker;
        _imageFile = null;
      });
    }
  }

  Future<void> _startRecording() async {
    if (!kIsWeb && await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder?.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover)
                : _webImage != null
                    ? Image.memory(_webImage!, width: 200, height: 200, fit: BoxFit.cover)
                    : const Text('No image selected.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickWebImage,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF057962)),
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Upload Data'),
            ),
            const SizedBox(height: 20),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
*/

/*
// without bottom nav
//updated with foundation.dart    with   Recorder Not Properly Closed:
//In dispose(), add a null check to prevent errors when closing the recorder.
import 'package:flutter/material.dart';
import 'dart:io'; // File handling
import 'package:image_picker/image_picker.dart'; // Image picking
import 'package:image_picker_web/image_picker_web.dart'; // Web image picking
import 'package:flutter_sound/flutter_sound.dart'; // Audio recording
import 'package:permission_handler/permission_handler.dart'; // Permissions
import 'package:path_provider/path_provider.dart'; // File storage
import 'package:flutter/foundation.dart'; // For kIsWeb

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // Stores selected image for mobile
  Uint8List? _webImage; // Stores web image
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      _initRecorder();
    }
  }

  Future<void> _initRecorder() async {
    await _recorder?.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to pick an image from web
  Future<void> _pickWebImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _webImage = bytesFromPicker;
        _imageFile = null; // Reset local image
      });
    }
  }

  // Function to start recording audio
  Future<void> _startRecording() async {
    if (!kIsWeb && await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder?.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  // Function to stop recording audio
  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  // Function to upload data
  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Preview
            _imageFile != null
                ? Image.file(_imageFile!,
                    width: 200, height: 200, fit: BoxFit.cover)
                : _webImage != null
                    ? Image.memory(_webImage!,
                        width: 200, height: 200, fit: BoxFit.cover)
                    : const Text('No image selected.',
                        style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Pick Image Buttons
            ElevatedButton(
              onPressed: _pickWebImage,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF057962)),
              child: const Text('Upload Image'),
            ),

            const SizedBox(height: 20),

            // Text Description Field
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Upload Button
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Upload Data'),
            ),

            const SizedBox(height: 20),

            // Voice Recording Button (only for mobile)
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child:
                    Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
          ],
        ),
      ),
    );
  }
}

*/
/*
import 'package:flutter/material.dart';
import 'dart:io'; // File handling
import 'package:image_picker/image_picker.dart'; // Image picking
import 'package:image_picker_web/image_picker_web.dart'; // Web image picking
import 'package:flutter_sound/flutter_sound.dart'; // Audio recording
import 'package:permission_handler/permission_handler.dart'; // Permissions
import 'package:path_provider/path_provider.dart'; // File storage
import 'dart:typed_data';



class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // Stores selected image for mobile
  Uint8List? _webImage; // Stores web image
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }
/*
  // Function to pick an image from device
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _webImage = null; // Reset web image
      });
    }
  }
*/
  // Function to pick an image from web
  Future<void> _pickWebImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _webImage = bytesFromPicker;
        _imageFile = null; // Reset local image
      });
    }
  }

  // Function to start recording audio
  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';
      await _recorder!.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });
    }
  }

  // Function to stop recording audio
  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  // Function to upload data
  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Preview
            _imageFile != null
                ? Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover)
                : _webImage != null
                    ? Image.memory(_webImage!, width: 200, height: 200, fit: BoxFit.cover)
                    : Text('No image selected.', style: TextStyle(fontSize: 18)),

            SizedBox(height: 20),

            // Pick Image Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               /* 
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text('Pick Local Image'),
                ),*/
                ElevatedButton(
                  onPressed: _pickWebImage,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 5, 121, 98)),
                  child: Text('upload '),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Text Description Field
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Upload Button
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Upload Data'),
            ),

            SizedBox(height: 20),

            // Voice Recording Button
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*

// upload with text,image,voice 
import 'package:flutter/material.dart';
import 'dart:io'; // File handling
import 'package:image_picker/image_picker.dart'; // Image picking
import 'package:flutter_sound/flutter_sound.dart'; // Audio recording
import 'package:permission_handler/permission_handler.dart'; // Permissions
import 'package:path_provider/path_provider.dart'; // File storage

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // Stores selected image
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to start recording audio
  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/recording.aac';

      await _recorder!.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
        _audioPath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording started...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission required!')),
      );
    }
  }

  // Function to stop recording audio
  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recording saved!')),
    );
  }

  // Function to upload image, description & audio
  void _uploadData() {
    String description = _descriptionController.text.trim();

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a description!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading Image, Description & Audio...')),
    );

    // Here you can send _imageFile, description, and _audioPath to backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Preview
            _imageFile == null
                ? Text('No image selected.', style: TextStyle(fontSize: 18))
                : Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),

            SizedBox(height: 20),

            // Pick Image Button
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text('Pick Image'),
            ),

            SizedBox(height: 20),

            // Text Description Field
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Upload Button
            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Upload Data'),
            ),

            SizedBox(height: 20),

            // Voice Recording Button
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
*/


/*
// upload without text ,with image and voice
import 'package:flutter/material.dart';
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 1; // Default to Upload tab

  // Voice Recording
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/recorded_audio.aac';
    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recording saved at $_filePath')),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image
      });
    }
  }

  // Function to upload the image
  void _uploadImage() {
    if (_imageFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading Image...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
    }
  }

  // Function to handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Stay on the upload page
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text(
                    'No image selected.',
                    style: TextStyle(fontSize: 18),
                  )
                : Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Upload Image'),
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 20),
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 100,
              color: _isRecording ? Colors.red : Colors.black,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

*/









/*   Explanation of the Modifications: Adding a Text Description Field
You wanted a text description area in addition to image upload and voice recording. Now, let’s break down the modifications step by step.

1️⃣ Adding a TextField for User Input
What we added:
We introduced a TextField widget so users can type a description for their image or recording.

Code:
dart
Copy
Edit
TextEditingController _descriptionController = TextEditingController();
This stores whatever the user types.
TextEditingController allows us to access the text input.
How It Works:
dart
Copy
Edit
TextField(
  controller: _descriptionController, // Connects TextField to controller
  maxLines: 4, // Allows multiline input
  decoration: InputDecoration(
    labelText: 'Enter Description', // Text hint
    border: OutlineInputBorder(), // Adds a box around input
  ),
),
Users type their description in this box.
It is stored inside _descriptionController.
2️⃣ Modifying the Upload Function
Why?
Now that we have a text description, we should include it in the upload function.

Modified _uploadImage() function:
dart
Copy
Edit
void _uploadImage() {
  String description = _descriptionController.text.trim(); // Get text input

  if (_imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No image selected!')),
    );
    return;
  }

  if (description.isEmpty) { // Prevents empty descriptions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a description!')),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Uploading Image & Description...')),
  );

  // Here you can send `_imageFile` and `description` to your backend
}
Changes & Benefits:
✅ Prevents users from uploading an empty image
✅ Prevents uploads without a description
✅ Displays a SnackBar notification if something is missing
✅ Simulates uploading both image and description

3️⃣ Combining All Features into a Unified UI
Now, the UI includes:
An image picker
A preview of the selected image
A text input field for the description
An upload button
A voice recording button
dart
Copy
Edit
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Image Display
    _imageFile == null
        ? Text('No image selected.', style: TextStyle(fontSize: 18))
        : Image.file(
            _imageFile!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),

    SizedBox(height: 20),

    // Button to Pick Image
    ElevatedButton(
      onPressed: _pickImage,
      child: Text('Pick Image'),
    ),

    SizedBox(height: 20),

    // TextField for Description
    TextField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Enter Description',
        border: OutlineInputBorder(),
      ),
    ),

    SizedBox(height: 20),

    // Upload Button
    ElevatedButton(
      onPressed: _uploadImage,
      child: Text('Upload Image & Description'),
    ),

    SizedBox(height: 20),

    // Voice Recording Button
    ElevatedButton(
      onPressed: _isRecording ? _stopRecording : _startRecording,
      child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
    ),
  ],
),
4️⃣ How the Final Code Works Together
User selects an image → The image is displayed.
User types a description → It is stored in _descriptionController.
User clicks "Upload Image & Description" →
If no image is selected, a warning message appears.
If no description is entered, a warning message appears.
If everything is correct, a confirmation message appears.
User can also record voice → Voice recording can be started or stopped.
SnackBar notifications provide real-time feedback.
🎯 Final Summary of Features
Feature	Function
Text Description Field	Users can type a description before uploading
Image Selection & Upload	Users can pick and upload an image
Voice Recording	Users can record and stop voice recording
SnackBar Notifications	Alerts users if something is missing or when uploading  */


/* //upload circle avathar image only no other details
import 'package:flutter/material.dart';
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart'; // For image picking

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 1; // Default to Upload tab

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image
      });
    }
  }

  // Function to upload the image
  void _uploadImage() {
    if (_imageFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading Image...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
    }
  }

  // Function to handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Stay on the upload page
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text(
                    'No image selected.',
                    style: TextStyle(fontSize: 18),
                  )
                : Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

*/










// without bottom nav


/* import 'package:flutter/material.dart';
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart'; // For image picking

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image
      });
    }
  }

  // Function to upload the image
  void _uploadImage() {
    if (_imageFile != null) {
      // Upload image logic here (e.g., send to server)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading Image...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text(
                    'No image selected.',
                    style: TextStyle(fontSize: 18),
                  )
                : Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),


      
    );
  }
}
*/