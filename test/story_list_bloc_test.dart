import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/features/catalog/application/story_list_bloc.dart';
import 'package:storytelling/features/catalog/application/story_list_event.dart';
import 'package:storytelling/features/catalog/application/story_list_state.dart';
import 'package:storytelling/app/di/injection_container.dart';

void main() {
  setUp(() async {
    await resetDependencies();
    await configureDependencies();
  });

  tearDown(() async {
    await resetDependencies();
  });

  group('StoryListBloc', () {
    blocTest<StoryListBloc, StoryListState>(
      'emits [loading, loaded] when started',
      build: () => getIt<StoryListBloc>(),
      act: (bloc) => bloc.add(const StoryListStarted()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<StoryListLoading>(),
        isA<StoryListLoaded>().having(
          (state) => state.stories.length,
          'stories.length',
          6,
        ),
      ],
    );
  });
}
