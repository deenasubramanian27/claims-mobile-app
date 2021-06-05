import 'Estimate.dart';

class Damage {
  Estimate estimate;

  Damage({this.estimate});

  factory Damage.fromJson(Map<String, dynamic> json) {
    return Damage(estimate: json['estimate']);
  }
}
