class DataStrains {
  final int id;
  final String strain;
  final String strainType;
  final String? imgThumb;
  final String goodEffects;
  final String? sideEffects;

  DataStrains(
      {required this.id,
      required this.strain,
      required this.strainType,
      required this.imgThumb,
      required this.goodEffects,
      required this.sideEffects});

  factory DataStrains.fromJson(Map<String, dynamic> json) {
    return DataStrains(
      id: json['id'],
      strain: json['strain'],
      strainType: json['strainType'],
      imgThumb: json['imgThumb'],
      goodEffects: json['goodEffects'],
      sideEffects: json['sideEffects'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'strain': strain,
      'strainType': strainType,
      'imgThumb': imgThumb,
      'goodEffects': goodEffects,
      'sideEffects': sideEffects,
    };
  }

  static DataStrains fromMap(Map<String, dynamic> map) {
    return DataStrains(
      id: map['id'],
      strain: map['strain'],
      strainType: map['strainType'],
      imgThumb: map['imgThumb'],
      goodEffects: map['goodEffects'],
      sideEffects: map['sideEffects'],
    );
  }
}
