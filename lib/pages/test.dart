import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadForm extends StatefulWidget {
  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  File? _imageFile;

  Future<void> _uploadData() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Upload image to Firebase Storage
      late String imageUrl;
      if (_imageFile != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/${_imageFile?.path}');
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        await uploadTask.whenComplete(() async {
          imageUrl = await storageReference.getDownloadURL();
        });
      }

      // Save data to Firebase Firestore
      // Replace 'YOUR_COLLECTION' with your desired collection name
      await FirebaseFirestore.instance
          .collection('flowers')
          .add({'name': _name, 'imageUrl': imageUrl});

      // Reset form
      _formKey.currentState?.reset();
      if (_imageFile != null) {
        setState(() {
          _imageFile = null;
        });
      }

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Data uploaded successfully!'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _takePhoto,
                    child: const Text('Take Photo'),
                  ),
                  const SizedBox(width: 20),
                  Text(_imageFile != null
                      ? _imageFile!.path
                      : 'No image selected'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadData,
                child: const Text('Upload Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
