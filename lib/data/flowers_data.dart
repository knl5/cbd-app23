import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final contributionList = FirebaseFirestore.instance;
Future<QuerySnapshot> flowers = contributionList.collection('flowers').get();

class FlowerList extends StatelessWidget {
  const FlowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: flowers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView(
                children: documents
                    .map((doc) => Card(
                          child: ListTile(
                            title: Text(doc['name']),
                            subtitle: Text(doc['type']),
                          ),
                        ))
                    .toList());
          } else if (snapshot.hasError) {
            return const Text('error');
          }
          return const CircularProgressIndicator();
        });
  }
}
