import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/flowers_data.dart';
import 'package:my_app/fonctionnalities/recommendation_list.dart';

class HomeLists extends StatelessWidget {
  const HomeLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBody: true,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: Row(
              children: [
                const Image(
                    image: AssetImage('assets/images/Marijane.png'), width: 60),
                const Text(
                  ' Hello, ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${currentUser!.displayName}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/hello-marijane.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 250,
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              'I\'m Marijane, your CBD assistant !',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                              width: 250,
                              child: Text(
                                'Did you know ? \nCBD works well for anxiety !',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(5.0, 5.0),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              '🍀 Last added by the community',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansPro',
                color: Colors.black,
              ),
            ),
          ),
          const Expanded(
            child: FlowerList(),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 30, bottom: 20, top: 20),
            child: Text(
              '👀 Your recommendations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansPro',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 350.0,
            child: RecoList(difficulty: 'Easy'),
          ),
        ],
      ),
    );
  }
}
