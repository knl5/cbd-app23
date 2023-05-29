import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/article.dart';

class ArticleElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('articles')
              .limit(1) // listen to the first document in collection
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final article = snapshot.data!.docs[0];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticlePage(article: article),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8.0,
                              spreadRadius: 1.0,
                              offset: Offset(
                                0, // Move to right 7.0 horizontally
                                8.0, // Move to bottom 8.0 Vertically
                              ))
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/background-cbd.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 350,
                      height: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 250,
                                  child: Text(
                                    article['title'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'SourceSansPro',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
