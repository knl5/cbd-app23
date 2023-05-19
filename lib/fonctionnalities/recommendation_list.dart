import 'package:flutter/material.dart';
import 'package:my_app/data/api_data.dart';
import 'package:my_app/data/fetch_data.dart';
import 'package:my_app/pages/details_strain.dart';

class RecoList extends StatefulWidget {
  final String difficulty;
  const RecoList({super.key, required this.difficulty});

  @override
  _RecoListState createState() => _RecoListState();
}

class _RecoListState extends State<RecoList> {
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: index % 2 == 0
                      ? const Color.fromARGB(255, 142, 127, 218)
                      : const Color.fromARGB(255, 85, 147, 135),
                ),
                width: 200.0,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: NetworkImage(data[index].imgThumb ?? 'None'),
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.dstATop,
                            color: Colors.black.withOpacity(0.8),
                            width: 150,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(data[index].strain,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.left),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Good Effects: ${data[index].goodEffects}',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
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