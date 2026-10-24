// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:expensetracker_ian/models/time_entry_model.dart';

void main() {
  test('Expense details survive saving and loading', () {
    final original = Expense(
      id: '1',
      categoryId: '2',
      subcategoryId: '3',
      amount: 12.50,
      date: DateTime(2026, 10, 24),
      notes: 'Test purchase',
      payee: 'Test Store',
    );

    final restored = Expense.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.categoryId, original.categoryId);
    expect(restored.subcategoryId, original.subcategoryId);
    expect(restored.amount, original.amount);
    expect(restored.date, original.date);
    expect(restored.notes, original.notes);
    expect(restored.payee, original.payee);
  });
}
