class DataModel {
  final int id;
  final String title;
  final String body;

  DataModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
