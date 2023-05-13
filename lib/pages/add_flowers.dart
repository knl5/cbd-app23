import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference flowersCollection =
    FirebaseFirestore.instance.collection('flowers');

Future<void> addFlowerToFirestore(
    String name, String type, String benefits, File image) async {
  // Upload the image to Firebase Storage
  final Reference storageRef = FirebaseStorage.instance
      .ref()
      .child('flower_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  final UploadTask uploadTask = storageRef.putFile(image);
  final TaskSnapshot downloadUrl = (await uploadTask);

  // Create a new document in the 'flowers' collection
  await flowersCollection.add({
    'name': name,
    'type': type,
    'benefits': benefits,
    'image_url': await downloadUrl.ref.getDownloadURL(),
    'created_at': FieldValue.serverTimestamp(),
  });
}

class FlowerForm extends StatefulWidget {
  const FlowerForm({super.key});

  @override
  _FlowerFormState createState() => _FlowerFormState();
}

class _FlowerFormState extends State<FlowerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _benefitsController = TextEditingController();
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Flower'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _getImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 64,
                        color: Colors.grey[400],
                      )
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _benefitsController,
              decoration: const InputDecoration(
                labelText: 'Benefits',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some benefits';
                }
                return null;
              },
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _image != null) {
                  addFlowerToFirestore(
                    _nameController.text,
                    _typeController.text,
                    _benefitsController.text,
                    _image!,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
