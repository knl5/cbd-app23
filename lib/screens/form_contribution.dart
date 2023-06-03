import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference flowersCollection =
    FirebaseFirestore.instance.collection('flowers');

Future<void> addFlowerToFirestore(String name, String type, String benefits,
    String review, File image) async {
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
    'review': review,
    'image_url': await downloadUrl.ref.getDownloadURL(),
    'created_at': FieldValue.serverTimestamp(),
  });
}

class FlowerForm extends StatefulWidget {
  const FlowerForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlowerFormState createState() => _FlowerFormState();
}

class _FlowerFormState extends State<FlowerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _reviewController = TextEditingController();
  File? _image;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select an image'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const Text('Take a picture'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.camera));
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text('Select from gallery'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _dismissKeyboard, // Dismiss keyboard when tapping outside
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Add a new flower/product',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro')),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: _selectImage,
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
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: 'Review, something you want to share ?',
                  border: OutlineInputBorder(),
                ),
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
                      _reviewController.text,
                      _image!,
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Flower added successfully.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _nameController.clear();
                                _typeController.clear();
                                _benefitsController.clear();
                                _reviewController.clear();
                                setState(() {
                                  _image = null;
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
