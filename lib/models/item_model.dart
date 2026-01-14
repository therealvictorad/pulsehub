class ItemModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String status; 

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.status = '',
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
        title: json['title'] ?? 'No Title',
        description: json['body'] ?? 'No Description',
        category: json['category'] ?? 'General',
        date: json['date'] ?? DateTime.now().toIso8601String(),
      );
}
