import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/di/injection_container.dart';
import 'package:storytelling/main.dart';
import 'package:storytelling/widgets/stroke_text.dart';

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

    expect(find.byType(StrokeText), findsOneWidget);
    expect(find.text('Too Big! Too Small!'), findsOneWidget);
  });

  testWidgets('Selecting a story opens its three-mode hub', (tester) async {
    await tester.pumpWidget(const StorytellingApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Too Big! Too Small!'));
    await tester.pumpAndSettle();

    expect(find.text('Con muốn làm gì?'), findsOneWidget);
    expect(find.text('Đọc truyện'), findsOneWidget);
    expect(find.text('Chơi'), findsOneWidget);
    expect(find.text('Luyện nói'), findsOneWidget);
    expect(find.text('Sắp ra mắt'), findsOneWidget);
  });
}
