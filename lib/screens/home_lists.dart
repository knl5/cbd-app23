import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/get_flowers.dart';
import 'package:my_app/features/blog_articles.dart';
import 'package:my_app/features/recommendation_list.dart';

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
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: [
                const Text(
                  ' Hello, ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                Text(
                  '${currentUser!.displayName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 140),
                  child: Image(
                      image: AssetImage('assets/images/Marijane.png'),
                      width: 60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text('Explore',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 127, 0, 255),
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              '🍀 Recent contribution',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansPro',
                color: Color.fromARGB(255, 108, 142, 71),
              ),
            ),
          ),
          const SizedBox(
            height: 350.0,
            child: FlowerList(),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Container(
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
                  image: const DecorationImage(
                    image: AssetImage('assets/images/hello-marijane.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                  shape: BoxShape.rectangle,
                ),
                width: 200,
                height: 200,
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
                                fontFamily: 'SourceSansPro',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                              width: 250,
                              child: Text(
                                '"Did you know ? \nCBD works well for anxiety !"',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'SourceSansPro',
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 30, bottom: 20),
            child: Text(
              '🌿 Your recommendations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansPro',
                color: Color.fromARGB(255, 108, 142, 71),
              ),
            ),
          ),
          const SizedBox(
            height: 350.0,
            child: RecommendationList(difficulty: 'Easy'),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 30, bottom: 20),
            child: Text(
              '📰 Latest articles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceSansPro',
                color: Color.fromARGB(255, 108, 142, 71),
              ),
            ),
          ),
          SizedBox(
            height: 350.0,
            width: 500,
            child: ArticleElement(),
          )
        ],
      ),
    );
  }
}
