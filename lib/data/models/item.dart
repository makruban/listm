class Item {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Item({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
