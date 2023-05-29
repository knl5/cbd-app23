import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/screens/favorites_strains.dart';
import 'package:my_app/functionalities/search_strain.dart';
import 'package:my_app/screens/home_lists.dart';
import 'package:my_app/screens/list_strains.dart';
import 'package:my_app/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'authentication/auth_gate.dart';
import 'screens/form_contribution.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_test_51N4KheG6sHh2uNYcrQWLZXYe6HG8v4f2oFeo6PP24kkVizd7pLb1F2WomYcuTtzh7rn17U2dUeh88YnnGi8kOOkH00vvnJGcUb';
  await Stripe.instance.applySettings();
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
      home: const WelcomeScreen(
        child: AuthGate(),
      ),
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

  final newPasswordController = TextEditingController();

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change my password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Change'),
              onPressed: () async {
                try {
                  await currentUser?.updatePassword(newPasswordController.text);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Failed, not possible to change password for Google account'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  late final List<Widget> _widgetOptions = <Widget>[
    const HomeLists(),
    const StrainsPage(
      title: 'All flowers',
    ),
    const FlowerForm(),
    const FavoritesPage(),
    ProfileScreen(actions: [
      SignedOutAction((context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      })
    ], children: [
      TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          alignment: Alignment.bottomLeft,
        ),
        label: const Text('Change Password'),
        icon: const Icon(Icons.lock),
        onPressed: () {
          _showChangePasswordDialog(context);
        },
      ),
    ]),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 6,
        backgroundColor: const Color.fromARGB(255, 127, 0, 255),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.black),
            label: 'Home',
            activeIcon: Icon(
              Icons.home_filled,
              color: Color.fromARGB(255, 127, 0, 255),
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.black),
            label: 'Strains',
            activeIcon: Icon(Icons.list_rounded,
                color: Color.fromARGB(255, 127, 0, 255), size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.black),
            label: 'Add',
            activeIcon: Icon(Icons.add_circle_sharp,
                color: Color.fromARGB(255, 127, 0, 255), size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined, color: Colors.black),
            label: 'Favorites',
            activeIcon: Icon(Icons.favorite,
                color: Color.fromARGB(255, 127, 0, 255), size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, color: Colors.black),
            label: 'Profil',
            activeIcon: Icon(Icons.person,
                color: Color.fromARGB(255, 127, 0, 255), size: 30),
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
