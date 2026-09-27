import 'package:flutter_test/flutter_test.dart';
import 'package:ian_profile_app/main.dart';

void main() {
  testWidgets('Profile page test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileApp());

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Ian'), findsOneWidget);
  });
}
