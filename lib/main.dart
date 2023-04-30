import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/pages/details_strain.dart';
import 'package:my_app/pages/favorites_strains.dart';
import 'package:my_app/fonctionnalities/search_strain.dart';
import 'package:my_app/pages/list_strains.dart';
import 'data/api_data.dart';
import 'data/fetch_data.dart';
import 'firebase_options.dart';
import 'authentification/auth_gate.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marijane CBD App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.comfortaaTextTheme(),
        brightness: Brightness.light,
        primaryColor: Colors.black,
        primarySwatch: Colors.deepPurple,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final ValueNotifier<String> _selectedFilter = ValueNotifier<String>("All");

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
                // Filter the data list based on the selected filter
                data = data
                    .where((item) =>
                        item.strainType == filter ||
                        item.goodEffects.contains(filter))
                    .toList();
              }
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
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
                                          builder: (context) => DetailsStrain(
                                              data: data[index])));
                                })));
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        );
      },
    ),
    const StrainsPage(
      title: 'All strains',
    ),
    const FavoritesPage(),
    Container(
      child: ProfileScreen(
        actions: [
          SignedOutAction((context) {
            Navigator.of(context).pop();
          })
        ],
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search)),
        ],
        automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: GoogleFonts.comfortaa(),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(
              Icons.home_filled,
              color: Colors.deepPurple,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Strains',
            activeIcon:
                Icon(Icons.list_rounded, color: Colors.deepPurple, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'My Favorites',
            activeIcon:
                Icon(Icons.favorite, color: Colors.deepPurple, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
            activeIcon: Icon(Icons.person, color: Colors.deepPurple, size: 30),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
