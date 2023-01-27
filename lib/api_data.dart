class Data {
  final int id;
  final String strain;
  final String strainType;
  final String imgThumb;

  Data(
      {required this.id,
      required this.strain,
      required this.strainType,
      required this.imgThumb});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      strain: json['strain'],
      strainType: json['strainType'],
      imgThumb: json['imgThumb'],
    );
  }
}
