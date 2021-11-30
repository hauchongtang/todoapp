class BreakTimeModel {
  final int? time;
  BreakTimeModel({this.time});

  Map<String, dynamic> toMap() {
    return {'id': 1, 'time': time};
  }
}
