import 'package:flutter/material.dart';
import 'package:my_app/data/models_data.dart';
import 'package:my_app/data/strains_data.dart';
import 'package:my_app/screens/strain_details.dart';

class RecommendationList extends StatefulWidget {
  final String difficulty;
  const RecommendationList({super.key, required this.difficulty});

  @override
  // ignore: library_private_types_in_public_api
  _RecoListState createState() => _RecoListState();
}

class _RecoListState extends State<RecommendationList> {
  List<DataStrains> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<DataStrains> fetchedData =
          await fetchDataFiltered(widget.difficulty);
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            const SizedBox(width: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsStrain(data: data[index])),
                );
              },
              child: Container(
                height: 330.0,
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
                width: 180.0,
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: NetworkImage(data[index].imgThumb ?? 'None'),
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.dstATop,
                            color: Colors.black.withOpacity(0.8),
                            width: 104,
                            height: 104,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          data[index].strain,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansPro',
                            color: Color.fromARGB(255, 127, 0, 255),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            data[index].goodEffects,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'SourceSansPro'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('8% CBD'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
