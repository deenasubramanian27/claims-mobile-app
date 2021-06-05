class Estimate {
  double d02Moderate;
  double d03Severe;
  double d01Minor;

  Estimate({this.d02Moderate, this.d03Severe, this.d01Minor});

  factory Estimate.fromJson(Map<String, dynamic> json) {
    return Estimate(
        d02Moderate: json['d02Moderate'],
        d03Severe: json['d03Severe'],
        d01Minor: json['d01Minor']);
  }
}
