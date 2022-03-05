class MyChoice {
  String? name;
  int? index;
  bool value = false;
  bool? isDone;
  MyChoice({this.name, this.index, this.isDone});

  factory MyChoice.fromJson(Map<String, dynamic> json) {
    return MyChoice(
      name: json['name'],
      index: json['index'],
      isDone: json['isDone'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        'index': index,
        "isDone": isDone,
      };
}
