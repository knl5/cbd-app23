import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';
import '../features/review_strain.dart';
import '../features/stripe_checkout.dart';
import '../features/form_review.dart';

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

  List<Color> getGaugeColors() {
    List<String> goodEffectsList = widget.data.goodEffects.split(',');
    int effectCount = goodEffectsList.length;
    List<Color> colors = [];
    if (effectCount <= 3) {
      colors = [
        const Color.fromARGB(255, 127, 0, 255),
        const Color.fromARGB(195, 128, 0, 255),
        const Color.fromARGB(139, 128, 0, 255)
      ];
    } else if (effectCount <= 4) {
      colors = [
        const Color.fromARGB(255, 127, 0, 255),
        const Color.fromARGB(195, 128, 0, 255),
        const Color.fromARGB(139, 128, 0, 255),
        const Color.fromARGB(95, 128, 0, 255),
      ];
    } else {
      colors = [
        const Color.fromARGB(255, 127, 0, 255),
        const Color.fromARGB(195, 128, 0, 255),
        const Color.fromARGB(139, 128, 0, 255),
        const Color.fromARGB(95, 128, 0, 255),
        const Color.fromARGB(59, 128, 0, 255),
      ];
    }

    // Adjust the colors to evenly distribute them across the gauge
    double colorStep = 1 / (colors.length - 1);
    List<Color> adjustedColors = [];
    for (int i = 0; i < colors.length - 1; i++) {
      double progress = i * colorStep;
      Color? color = Color.lerp(colors[i], colors[i + 1], progress);
      adjustedColors.add(color!);
    }
    adjustedColors.add(colors.last);

    return adjustedColors;
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
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Text('THC '),
                        Text('< 0.2%'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Goods Effects:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.data.goodEffects,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    CustomPaint(
                      painter: GaugePainter(
                        colors: getGaugeColors(),
                        value: widget.data.goodEffects.split(',').length,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 240,
                          maxHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    ReviewStrain(data: widget.data),
                    const SizedBox(height: 2),
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

class GaugePainter extends CustomPainter {
  final List<Color> colors;
  final int value;

  GaugePainter({required this.colors, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    double sectionWidth = size.width / (colors.length - 1);
    for (int i = 0; i < colors.length - 1; i++) {
      double startX = i * sectionWidth;
      double endX = (i + 1) * sectionWidth;
      Rect sectionRect = Rect.fromLTRB(startX, 0, endX, size.height);
      Paint sectionPaint = Paint()..color = colors[i];
      canvas.drawRect(sectionRect, sectionPaint);
    }

    // Calculate the value indicator position
    double indicatorX = value * sectionWidth;
    Paint indicatorPaint = Paint()..color = colors.last;
    canvas.drawRect(
        Rect.fromLTRB(indicatorX, 0, size.width, size.height), indicatorPaint);
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.value != value;
  }
}
