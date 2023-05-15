import 'package:flutter/material.dart';

import '../data/api_data.dart';
import '../data/fetch_data.dart';
import 'details_strain.dart';

class StrainsPage extends StatefulWidget {
  const StrainsPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _StrainsPageState();
}

class _StrainsPageState extends State<StrainsPage> {
  int _selectedIndex = 0;
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
                      height: 100,
                      width: 300,
                      child: Card(
                        child: ListTile(
                            title: Text(data[index].strain),
                            subtitle: Text([
                              data[index].strainType,
                              data[index].goodEffects
                            ].join(' | ')),
                            textColor: Colors.black,
                            isThreeLine: false,
                            leading: Image(
                                image: NetworkImage(
                                    data[index].imgThumb ?? 'None')),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsStrain(data: data[index])));
                            }),
                      ),
                    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Filter by type of plant or by need',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
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
      appBar: AppBar(
        title: const Text('All Strains'),
        foregroundColor: Colors.green[700],
        backgroundColor: Colors.white38,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: const Icon(Icons.filter_list),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
