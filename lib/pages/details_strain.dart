import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';
/* import 'package:my_app/fonctionnalities/stripe_service.dart';*/
import '../fonctionnalities/review_strain.dart';
import '../fonctionnalities/stripe_checkout.dart';

class DetailsStrain extends StatefulWidget {
  final DataStrains data;
  const DetailsStrain({Key? key, required this.data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailsStrainState createState() => _DetailsStrainState();
}

class _DetailsStrainState extends State<DetailsStrain> {
  bool isFavorited = false;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  int _rating = 0;

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
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFavorited();
  }

  Future<void> checkIfFavorited() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(widget.data.id.toString())
          .get();
      setState(() {
        isFavorited = docSnapshot.exists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Strain Details',
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  child: Image(
                      image: NetworkImage(widget.data.imgThumb ?? 'None')),
                ),
                IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : null,
                  ),
                  onPressed: () async {
                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      // Redirect the user to the login page if they are not logged in
                      // You can add your own logic here for handling user authentication
                      return;
                    }
                    setState(() {
                      isFavorited = !isFavorited;
                    });
                    final userId = user.uid;
                    final data = widget.data.toMap();
                    if (isFavorited) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('favorites')
                          .doc(widget.data.id.toString())
                          .set(data);
                    } else {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('favorites')
                          .doc(widget.data.id.toString())
                          .delete();
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 5,
                      bottom: 10,
                    ),
                    child: Text([widget.data.strain, widget.data.strainType]
                        .join(' | ')),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 5,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckoutPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Buy it'),
                    ))
              ],
            ),
            ListTile(
              title: const Text('Good Effects'),
              subtitle: Text(widget.data.goodEffects),
            ),
            ListTile(
              title: const Text('Side Effects'),
              subtitle: Text(widget.data.sideEffects ?? 'None'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('strains')
                  .doc(widget.data.id.toString())
                  .collection('reviews')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reviews = snapshot.data!.docs
                    .map((doc) => Review(
                          userId: doc['userId'],
                          strainId: doc['strainId'],
                          userName: doc['userName'],
                          text: doc['text'],
                          rating: doc['rating'],
                        ))
                    .toList();
                final totalRating =
                    reviews.fold<int>(0, (sum, review) => sum + review.rating);
                final averageRating =
                    reviews.isEmpty ? 0 : totalRating ~/ reviews.length;
                return Column(
                  children: [
                    Text(
                      'Average Rating: $averageRating',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ListTile(
                          title: Text(review.userName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(review.rating.toString()),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Text(review.text),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Add a Review',
              style: TextStyle(fontSize: 18),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Review Text',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a review';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
