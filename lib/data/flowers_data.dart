import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/pages/favorites_strains.dart';
import 'package:my_app/pages/list_strains.dart';

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
          return ListView(
            children: [
              Text(
                'New CBD Flowers',
                style: Theme.of(context).textTheme.headline4,
              ),
              Column(
                children: documents
                    .map((doc) => Card(
                          child: ListTile(
                            title: Text(doc['name']),
                            subtitle: Text(doc['type']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlowerDetailsPage(
                                    flower: doc,
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                    .toList(),
              ),
              Text(
                'CBD Flowers most popular',
                style: Theme.of(context).textTheme.headline4,
              ),
              Column(),
            ],
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
                      bottom: 15,
                    ),
                    child: Text(
                      [flower['name'], flower['type']].join(' | '),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: const Text('Good Effects'),
              subtitle: Text(flower['benefits']),
            ),
          ],
        ),
      ),
    );
  }
}
