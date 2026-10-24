class ExpenseSubcategory {
  final String id;
  final String name;

  ExpenseSubcategory({required this.id, required this.name});

  factory ExpenseSubcategory.fromJson(Map<String, dynamic> json) {
    return ExpenseSubcategory(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
