class Review {
  final String userId;
  final String userName;
  final String strainId;
  final String text;
  final int rating;

  Review({
    required this.strainId,
    required this.userName,
    required this.userId,
    required this.text,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'strainId': strainId,
      'userName': userName,
      'userId': userId,
      'text': text,
      'rating': rating,
    };
  }
}
