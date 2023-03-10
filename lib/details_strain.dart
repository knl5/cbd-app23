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
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                child: Image(image: NetworkImage(widget.data.imgThumb)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 20,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Text(
                      [widget.data.strain, widget.data.strainType].join('  ')),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text('Good Effects'),
            subtitle: Text(widget.data.goodEffects),
          ),
        ],
      ),
    );
  }
}
