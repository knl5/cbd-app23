import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';
import '../fonctionnalities/review_strain.dart';
import '../fonctionnalities/stripe_checkout.dart';
import '../fonctionnalities/form_review.dart';

class DetailsStrain extends StatefulWidget {
  final DataStrains data;
  const DetailsStrain({Key? key, required this.data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailsStrainState createState() => _DetailsStrainState();
}

class _DetailsStrainState extends State<DetailsStrain> {
  bool isFavorited = false;

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
          widget.data.strain,
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data.strain,
                        style: GoogleFonts.comfortaa(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
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
                            bottom: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: 5,
                      right: 10,
                      child: TextButton.icon(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckoutPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 85, 147, 135),
                        ),
                        label: const Text('Buy'),
                      )),
                  const SizedBox(height: 20),
                  Text(
                    'Type: ${widget.data.strainType}',
                    style: GoogleFonts.comfortaa(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.data.goodEffects,
                    style: GoogleFonts.comfortaa(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ReviewStrain(data: widget.data),
                  const SizedBox(height: 20),
                  FormReview(data: widget.data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
