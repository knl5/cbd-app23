import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                            borderRadius: BorderRadius.circular(30),
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
        title: Text(flower['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  child: Image(
                    image: NetworkImage(flower['image_url']),
                  ),
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
                    child: Text(
                      [flower['name'], flower['type']].join(' | '),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: ListTile(
                title: const Text('Good Effects'),
                subtitle: Text(flower['benefits']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
