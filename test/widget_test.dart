import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/di/injection_container.dart';
import 'package:storytelling/main.dart';

void main() {
  setUp(() async {
    await resetDependencies();
    await configureDependencies();
  });

  tearDown(() async {
    await resetDependencies();
  });

  testWidgets('Home shows story list from mock repository', (tester) async {
    await tester.pumpWidget(const StorytellingApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Kể chuyện'), findsOneWidget);
    expect(find.text('Too Big! Too Small!'), findsOneWidget);
  });
}
