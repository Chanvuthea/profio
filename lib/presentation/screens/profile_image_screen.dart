import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageEditorScreen extends StatefulWidget {
  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  Uint8List? imageData;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    loadAsset();
    super.initState();
  }

  void loadAsset() async {
    final prefs = await SharedPreferences.getInstance();
    String? base64Image = prefs.getString('myImageKey');
    if (base64Image != null) {
      Uint8List decodedBytes = base64Decode(base64Image);
      setState(() {
        imageData = decodedBytes;
      });
    }
  }

  Future<void> saveImageToPrefs(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    await prefs.setString('myImageKey', base64Image);
  }

  Future<void> _pickImage({bool fromCamera = true}) async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera permission denied')));
      return;
    }
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      saveImageToPrefs(imageBytes);
      setState(() {
        imageData = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          if (imageData != null)
            Center(
              child: ClipOval(
                child: Image.memory(
                  imageData!,
                  height: 250.0,
                  width: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Center(
              child: ClipOval(
                child: Container(
                  color: Colors.grey[300],
                  height: 250.0,
                  width: 250.0,
                ),
              ),
            ),
          SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pickImage(fromCamera: true);
                  },
                  child: Text('Open Camera'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(fromCamera: false);
                  },
                  child: Text('Gallery'),
                ),
              ],
            ),
          ),

          if (imageData != null)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  var editedImage = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageEditor(image: imageData),
                    ),
                  );
                  if (editedImage != null) {
                    imageData = editedImage;
                    setState(() {
                      imageData = imageData;
                    });
                    saveImageToPrefs(imageData!);
                  }
                },
                child: Text('Edit Image'),
              ),
            ),
        ],
      ),
    );
  }
}
