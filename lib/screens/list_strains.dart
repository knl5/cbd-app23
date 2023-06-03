import 'package:flutter/material.dart';

import '../data/models_data.dart';
import '../data/strains_data.dart';
import 'strain_details.dart';

class StrainsPage extends StatefulWidget {
  const StrainsPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _StrainsPageState();
}

class _StrainsPageState extends State<StrainsPage> {
  final int _selectedIndex = 0;
  final ValueNotifier<String> _selectedFilter = ValueNotifier<String>("All");

  void _onFilterPressed(String filter) {
    setState(() {
      _selectedFilter.value = filter;
    });
  }

  late final List<Widget> _widgetOptions = <Widget>[
    ValueListenableBuilder(
      valueListenable: _selectedFilter,
      builder: (BuildContext context, String filter, Widget? child) {
        return FutureBuilder<List<DataStrains>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DataStrains> data = snapshot.data!;
              if (filter != "All") {
                data = data
                    .where((item) =>
                        item.strainType == filter ||
                        item.goodEffects.contains(filter))
                    .toList();
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: 200,
                        width: 200,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsStrain(data: data[index])));
                            },
                            child: Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 15),
                                color: const Color(0xfff8f8f8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              color: const Color.fromARGB(
                                                  255, 226, 241, 218),
                                              child: Image(
                                                image: NetworkImage(
                                                    data[index].imgThumb ??
                                                        'None'),
                                                fit: BoxFit.cover,
                                                colorBlendMode:
                                                    BlendMode.dstATop,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            )),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(data[index].strain,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SourceSansPro',
                                                  color: Color.fromARGB(
                                                      255, 127, 0, 255),
                                                )),
                                            const SizedBox(height: 10),
                                            Text(
                                                [data[index].strainType, 'CBD']
                                                    .join(' • '),
                                                style: const TextStyle(
                                                  fontFamily: 'SourceSansPro',
                                                )),
                                            Column(children: [
                                              Container(
                                                width: 220,
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Text(
                                                  data[index].goodEffects,
                                                  style: const TextStyle(
                                                    fontFamily: 'SourceSansPro',
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ]),
                                          ],
                                        )
                                      ],
                                    )))));
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        );
      },
    ),
  ];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 2,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Filter by type of plant or by need',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro')),
            ),
            ListTile(
              title: const Text('All'),
              onTap: () {
                _onFilterPressed('All');
                Navigator.pop(context);
              },
              textColor:
                  _selectedFilter.value == 'All' ? Colors.deepPurple : null,
            ),
            ListTile(
              title: const Text('Sativa'),
              onTap: () {
                _onFilterPressed('Sativa');
                Navigator.pop(context);
              },
              textColor:
                  _selectedFilter.value == 'Sativa' ? Colors.deepPurple : null,
            ),
            ListTile(
              title: const Text('Hybrid'),
              onTap: () {
                _onFilterPressed('Hybrid');
                Navigator.pop(context);
              },
              textColor:
                  _selectedFilter.value == 'Hybrid' ? Colors.deepPurple : null,
            ),
            ListTile(
              title: const Text('Indica'),
              onTap: () {
                _onFilterPressed('Indica');
                Navigator.pop(context);
              },
              textColor:
                  _selectedFilter.value == 'Indica' ? Colors.deepPurple : null,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6.0),
              child: Divider(color: Colors.black),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('Focused'),
                    onTap: () {
                      _onFilterPressed('focused');
                      Navigator.pop(context);
                    },
                    textColor: _selectedFilter.value == 'focused'
                        ? Colors.deepPurple
                        : null,
                  ),
                  ListTile(
                    title: const Text('Relaxed'),
                    onTap: () {
                      _onFilterPressed('relaxed');
                      Navigator.pop(context);
                    },
                    textColor: _selectedFilter.value == 'relaxed'
                        ? Colors.deepPurple
                        : null,
                  ),
                  ListTile(
                    title: const Text('Sleepy'),
                    onTap: () {
                      _onFilterPressed('sleepy');
                      Navigator.pop(context);
                    },
                    textColor: _selectedFilter.value == 'sleepy'
                        ? Colors.deepPurple
                        : null,
                  ),
                  ListTile(
                    title: const Text('Energetic'),
                    onTap: () {
                      _onFilterPressed('energetic');
                      Navigator.pop(context);
                    },
                    textColor: _selectedFilter.value == 'energetic'
                        ? Colors.deepPurple
                        : null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: const Icon(Icons.filter_list),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
