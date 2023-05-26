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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(widget.data.imgThumb ?? 'None'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
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
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: TextButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 85, 147, 135),
                      ),
                      label: const Text('Buy'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              transform: Matrix4.translationValues(0, -25, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.strainType,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ListTile(
                      title: Text('THC'),
                      subtitle: Text('<0.2%'),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Goods Effects:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.data.goodEffects,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    ReviewStrain(data: widget.data),
                    FormReview(data: widget.data),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
