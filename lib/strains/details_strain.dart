import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/api_data.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Strain Details',
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                child:
                    Image(image: NetworkImage(widget.data.imgThumb ?? 'None')),
              ),
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : null,
                ),
                onPressed: () async {
                  setState(() {
                    isFavorited = !isFavorited;
                  });
                  final User? user = FirebaseAuth.instance.currentUser;
                  final userId = user?.uid ?? 'defaultUserId';
                  final data = widget.data.toMap();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('favorites')
                      .add(data);
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
                    bottom: 10,
                  ),
                  child: Text(
                      [widget.data.strain, widget.data.strainType].join(' | ')),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text('Good Effects'),
            subtitle: Text(widget.data.goodEffects),
          ),
          ListTile(
            title: const Text('Side Effects'),
            subtitle: Text(widget.data.sideEffects ?? 'None'),
          ),
        ],
      ),
    );
  }
}