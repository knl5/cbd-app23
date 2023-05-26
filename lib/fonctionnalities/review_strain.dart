import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/data/api_data.dart';

class Review {
  final String userId;
  final String userName;
  final String strainId;
  final String text;
  final int rating;

  Review({
    required this.userId,
    required this.userName,
    required this.strainId,
    required this.text,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'strainId': strainId,
      'text': text,
      'rating': rating,
    };
  }
}

class ReviewStrain extends StatelessWidget {
  final DataStrains data;

  const ReviewStrain({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 4, bottom: 8),
          child: Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 127, 0, 255),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('strains')
              .doc(data.id.toString())
              .collection('reviews')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final reviews = snapshot.data!.docs
                .map((doc) => Review(
                      userId: doc['userId'],
                      strainId: doc['strainId'],
                      userName: doc['userName'],
                      text: doc['text'],
                      rating: doc['rating'],
                    ))
                .toList();
            final totalRating =
                reviews.fold<int>(0, (sum, review) => sum + review.rating);
            final averageRating =
                reviews.isEmpty ? 0 : totalRating ~/ reviews.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Rate: $averageRating/5',
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.all(5),
                      color: const Color.fromARGB(255, 239, 239, 238),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(review.rating.toString()),
                                    const Icon(Icons.star,
                                        color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text.rich(
                                      TextSpan(
                                        text: ' " ',
                                        children: [
                                          TextSpan(
                                            text: review.text,
                                          ),
                                          const TextSpan(
                                            text: ' " ',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
