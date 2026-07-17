// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Story Time';

  @override
  String get homeTitle => 'Story Time';

  @override
  String loadStoriesError(String message) {
    return 'Oops, stories did not load: $message';
  }

  @override
  String get hubQuestion => 'What do you want to do?';

  @override
  String get readStoryTitle => 'Read';

  @override
  String get readStorySubtitle => 'Listen and read each word';

  @override
  String get readStoryAction => 'Start';

  @override
  String get playTitle => 'Play';

  @override
  String get playSubtitle => 'Put the pictures in order';

  @override
  String get playAction => 'Play';

  @override
  String get speakTitle => 'Talk';

  @override
  String get speakSubtitle => 'Read out loud';

  @override
  String get speakAction => 'Talk';

  @override
  String get comingSoon => 'Soon';

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String pagesCount(int count) {
    return '$count pages';
  }

  @override
  String readerPageCount(int current, int total) {
    return 'Page $current/$total';
  }

  @override
  String readerError(String message) {
    return 'Oops: $message';
  }

  @override
  String get readerFinishedStatus => 'All done!';

  @override
  String get readerSpeakingStatus => 'Reading...';

  @override
  String get readerPausedStatus => 'Paused';

  @override
  String get readerIdleStatus => 'Tap play';

  @override
  String get autoTurnPage => 'Auto page';

  @override
  String get finishReading => 'Done';

  @override
  String get completionTitle => 'Great job!';

  @override
  String completionMessage(String title) {
    return 'You finished\n\"$title\"';
  }

  @override
  String get listenAgainQuestion => 'Listen again?';

  @override
  String get listenAgainAction => 'Start over';

  @override
  String get playGameQuestion => 'Play a game?';

  @override
  String get playGameAction => 'Play with this story';

  @override
  String get gameSubtitle => 'Put pages in order';

  @override
  String get gameCompleteTitle => 'All done!';

  @override
  String get gameCompleteMessage => 'You put the pictures in order!';

  @override
  String get puzzleNoPictures => 'No pictures to play yet.';

  @override
  String get puzzleSolved => 'Yay! The pages are in order.';

  @override
  String get puzzleInstructions =>
      'Tap a picture, then tap a page spot.\nYou can also drag it.';

  @override
  String get puzzleSelected => 'Picture picked. Tap a page spot.';

  @override
  String get puzzlePiecesTitle => 'Pictures';

  @override
  String get shuffleAgain => 'Mix again';

  @override
  String pageLabel(int number) {
    return 'Page $number';
  }

  @override
  String talkPageCount(int current, int total) {
    return 'Page $current/$total';
  }

  @override
  String get talkEmpty => 'No words to say yet.';

  @override
  String get talkReadyStatus => 'Ready?';

  @override
  String get talkListeningStatus => 'I am listening...';

  @override
  String get talkDoneStatus => 'Nice reading!';

  @override
  String get talkStart => 'Start';

  @override
  String get talkStop => 'Done';

  @override
  String get talkNext => 'Next';

  @override
  String get talkPrevious => 'Back';

  @override
  String get talkCompleteTitle => 'Great voice!';

  @override
  String get talkCompleteMessage => 'You talked through every page.';
}
