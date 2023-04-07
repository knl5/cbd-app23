import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view favorites.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List favorites = snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            final data = document.data();
            return DataStrains.fromMap(data!);
          }).toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('You have no favorites yet.'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              final favorite = favorites[index];
              return ListTile(
                title: Text(favorite.strain),
                subtitle: Text(favorite.strainType),
              );
            },
          );
        },
      ),
    );
  }
}
