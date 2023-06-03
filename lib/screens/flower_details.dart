import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screens/strain_details.dart';

class FlowerDetailsPage extends StatelessWidget {
  final DocumentSnapshot flower;

  const FlowerDetailsPage({required this.flower, Key? key}) : super(key: key);

  List<Color> getGaugeColors() {
    List<String> goodEffectsList = flower['benefits'].split(',');
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
          flower['name'],
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
                    image: NetworkImage(flower['image_url'] ?? 'None'),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Container(
              height: 500,
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
                      flower['name'],
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
                    const SizedBox(height: 30),
                    const Text(
                      'Goods Effects:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      flower['benefits'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    CustomPaint(
                      painter: GaugePainter(
                        colors: getGaugeColors(),
                        value: flower['benefits'].split(',').length,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 240,
                          maxHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: flower['review'] != "",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Review from contributor:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            flower['review'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
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
