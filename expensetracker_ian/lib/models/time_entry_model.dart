class Expense {
  final String id;
  final String categoryId;
  final String subcategoryId;
  final double amount;
  final DateTime date;
  final String notes;
  final String payee;

  Expense({
    required this.id,
    required this.categoryId,
    required this.subcategoryId,
    required this.amount,
    required this.date,
    required this.notes,
    this.payee = '',
  });

  // Convert a JSON object to an Expense instance
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      categoryId: json['projectId'],
      subcategoryId: json['taskId'],
      amount: json['totalTime'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      payee: json['payee'] ?? '',
    );
  }

  // Convert an Expense instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': categoryId,
      'taskId': subcategoryId,
      'totalTime': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      'payee': payee,
    };
  }
}
