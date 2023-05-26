import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';
import 'package:my_app/fonctionnalities/review_strain.dart';

class FormReview extends StatefulWidget {
  final DataStrains data;

  const FormReview({Key? key, required this.data}) : super(key: key);

  @override
  _FormReviewState createState() => _FormReviewState();
}

class _FormReviewState extends State<FormReview> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  int _rating = 0;
  bool _showForm = false;

  void _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Redirect the user to the login page if they are not logged in
      // You can add your own logic here for handling user authentication
      return;
    }

    final strainId = widget.data.id.toString();
    final existingReview = await FirebaseFirestore.instance
        .collection('strains')
        .doc(strainId)
        .collection('reviews')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();
    if (existingReview.docs.isNotEmpty) {
      // The user has already made a review for this strain
      // You can add your own logic here for handling this case
      return;
    }
    if (_formKey.currentState!.validate()) {
      final review = Review(
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        strainId: strainId,
        text: _textController.text,
        rating: _rating,
      );
      await FirebaseFirestore.instance
          .collection('strains')
          .doc(strainId)
          .collection('reviews')
          .add(review.toMap());
      _textController.clear();
      setState(() {
        _rating = 0;
        _showForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showForm = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 85, 147, 135),
              ),
              onPressed: () {
                setState(() {
                  _showForm = true;
                });
              },
              label: const Text('Add a review',
                  style: TextStyle(fontSize: 16, fontFamily: 'SourceSansPro')),
              icon: const Icon(Icons.add_comment),
            ),
          ),
        ),
        if (_showForm)
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 4),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star),
                      color: _rating >= 1 ? Colors.orange : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _rating = 1;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star),
                      color: _rating >= 2 ? Colors.orange : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _rating = 2;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star),
                      color: _rating >= 3 ? Colors.orange : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _rating = 3;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star),
                      color: _rating >= 4 ? Colors.orange : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _rating = 4;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star),
                      color: _rating >= 5 ? Colors.orange : Colors.grey,
                      onPressed: () {
                        setState(() {
                          _rating = 5;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8, right: 8, bottom: 2.0),
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Describe your experience',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 127, 0, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
