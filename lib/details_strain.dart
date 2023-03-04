import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/api_data.dart';

class DetailsStrain extends StatefulWidget {
  final Data data;
  const DetailsStrain({Key? key, required this.data}) : super(key: key);

  @override
  _DetailsStrainState createState() => _DetailsStrainState();
}

class _DetailsStrainState extends State<DetailsStrain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Strain Details',
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: Container(
        width: 160.0,
        height: 200,
        child: Text(widget.data.strain),
      ),
    );
  }
}
