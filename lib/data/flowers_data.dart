import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

final contributionList = FirebaseFirestore.instance;
Future<QuerySnapshot> flowers = contributionList.collection('flowers').get();

class FlowerList extends StatelessWidget {
  const FlowerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: contributionList.collection('flowers').get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: documents
                  .map(
                    (doc) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FlowerDetailsPage(flower: doc),
                          ),
                        );
                      },
                      child: Container(
                        width: 200.0,
                        height: 350.0,
                        margin: const EdgeInsets.only(left: 25.0),
                        child: Container(
                          height: 350.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 239, 239, 238),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: NetworkImage(doc['image_url']),
                                  fit: BoxFit.cover,
                                  colorBlendMode: BlendMode.dstATop,
                                  color: Colors.black.withOpacity(0.8),
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                doc['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  color: Color.fromARGB(255, 127, 0, 255),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  doc['benefits'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SourceSansPro'),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class FlowerDetailsPage extends StatelessWidget {
  final DocumentSnapshot flower;

  const FlowerDetailsPage({required this.flower, Key? key}) : super(key: key);

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
                      flower['benefits'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
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
