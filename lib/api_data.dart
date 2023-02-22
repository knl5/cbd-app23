class Data {
  final int id;
  final String strain;
  final String strainType;
  final String imgThumb;
  final String goodEffects;

  Data(
      {required this.id,
      required this.strain,
      required this.strainType,
      required this.imgThumb,
      required this.goodEffects});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      strain: json['strain'],
      strainType: json['strainType'],
      goodEffects: json['goodEffects'],
      imgThumb: json['imgThumb'],
    );
  }
}
