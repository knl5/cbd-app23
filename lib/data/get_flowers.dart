import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/flower_details.dart';

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
                        width: 180.0,
                        height: 330.0,
                        margin: const EdgeInsets.only(left: 25.0),
                        child: Container(
                          height: 320.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3f000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: const Color(0xfff8f8f8),
                          ),
                          padding: const EdgeInsets.only(
                            top: 25,
                            bottom: 30,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 25),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: NetworkImage(doc['image_url']),
                                  fit: BoxFit.cover,
                                  colorBlendMode: BlendMode.dstATop,
                                  color: Colors.black.withOpacity(0.8),
                                  width: 104,
                                  height: 104,
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
                                  textAlign: TextAlign.center,
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
