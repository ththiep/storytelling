import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Story Time'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Story Time'**
  String get homeTitle;

  /// No description provided for @loadStoriesError.
  ///
  /// In en, this message translates to:
  /// **'Oops, stories did not load: {message}'**
  String loadStoriesError(String message);

  /// No description provided for @hubQuestion.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get hubQuestion;

  /// No description provided for @readStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readStoryTitle;

  /// No description provided for @readStorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Listen and read each word'**
  String get readStorySubtitle;

  /// No description provided for @readStoryAction.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get readStoryAction;

  /// No description provided for @playTitle.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playTitle;

  /// No description provided for @playSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Put the pictures in order'**
  String get playSubtitle;

  /// No description provided for @playAction.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playAction;

  /// No description provided for @speakTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk'**
  String get speakTitle;

  /// No description provided for @speakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read out loud'**
  String get speakSubtitle;

  /// No description provided for @speakAction.
  ///
  /// In en, this message translates to:
  /// **'Talk'**
  String get speakAction;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoon;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesCount(int count);

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String pagesCount(int count);

  /// No description provided for @readerPageCount.
  ///
  /// In en, this message translates to:
  /// **'Page {current}/{total}'**
  String readerPageCount(int current, int total);

  /// No description provided for @readerError.
  ///
  /// In en, this message translates to:
  /// **'Oops: {message}'**
  String readerError(String message);

  /// No description provided for @readerFinishedStatus.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get readerFinishedStatus;

  /// No description provided for @readerSpeakingStatus.
  ///
  /// In en, this message translates to:
  /// **'Reading...'**
  String get readerSpeakingStatus;

  /// No description provided for @readerPausedStatus.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get readerPausedStatus;

  /// No description provided for @readerIdleStatus.
  ///
  /// In en, this message translates to:
  /// **'Tap play'**
  String get readerIdleStatus;

  /// No description provided for @autoTurnPage.
  ///
  /// In en, this message translates to:
  /// **'Auto page'**
  String get autoTurnPage;

  /// No description provided for @finishReading.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get finishReading;

  /// No description provided for @completionTitle.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get completionTitle;

  /// No description provided for @completionMessage.
  ///
  /// In en, this message translates to:
  /// **'You finished\n\"{title}\"'**
  String completionMessage(String title);

  /// No description provided for @listenAgainQuestion.
  ///
  /// In en, this message translates to:
  /// **'Listen again?'**
  String get listenAgainQuestion;

  /// No description provided for @listenAgainAction.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get listenAgainAction;

  /// No description provided for @playGameQuestion.
  ///
  /// In en, this message translates to:
  /// **'Play a game?'**
  String get playGameQuestion;

  /// No description provided for @playGameAction.
  ///
  /// In en, this message translates to:
  /// **'Play with this story'**
  String get playGameAction;

  /// No description provided for @gameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Put pages in order'**
  String get gameSubtitle;

  /// No description provided for @gameCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get gameCompleteTitle;

  /// No description provided for @gameCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You put the pictures in order!'**
  String get gameCompleteMessage;

  /// No description provided for @puzzleNoPictures.
  ///
  /// In en, this message translates to:
  /// **'No pictures to play yet.'**
  String get puzzleNoPictures;

  /// No description provided for @puzzleSolved.
  ///
  /// In en, this message translates to:
  /// **'Yay! The pages are in order.'**
  String get puzzleSolved;

  /// No description provided for @puzzleInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap a picture, then tap a page spot.\nYou can also drag it.'**
  String get puzzleInstructions;

  /// No description provided for @puzzleSelected.
  ///
  /// In en, this message translates to:
  /// **'Picture picked. Tap a page spot.'**
  String get puzzleSelected;

  /// No description provided for @puzzlePiecesTitle.
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get puzzlePiecesTitle;

  /// No description provided for @shuffleAgain.
  ///
  /// In en, this message translates to:
  /// **'Mix again'**
  String get shuffleAgain;

  /// No description provided for @pageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String pageLabel(int number);

  /// No description provided for @talkPageCount.
  ///
  /// In en, this message translates to:
  /// **'Page {current}/{total}'**
  String talkPageCount(int current, int total);

  /// No description provided for @talkEmpty.
  ///
  /// In en, this message translates to:
  /// **'No words to say yet.'**
  String get talkEmpty;

  /// No description provided for @talkReadyStatus.
  ///
  /// In en, this message translates to:
  /// **'Ready?'**
  String get talkReadyStatus;

  /// No description provided for @talkListeningStatus.
  ///
  /// In en, this message translates to:
  /// **'I am listening...'**
  String get talkListeningStatus;

  /// No description provided for @talkDoneStatus.
  ///
  /// In en, this message translates to:
  /// **'Nice reading!'**
  String get talkDoneStatus;

  /// No description provided for @talkStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get talkStart;

  /// No description provided for @talkStop.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get talkStop;

  /// No description provided for @talkRecordAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get talkRecordAgain;

  /// No description provided for @talkPlayRecording.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get talkPlayRecording;

  /// No description provided for @talkRecordingError.
  ///
  /// In en, this message translates to:
  /// **'Oops, I could not record. Try again.'**
  String get talkRecordingError;

  /// No description provided for @talkPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'Oops, I could not play it.'**
  String get talkPlaybackError;

  /// No description provided for @talkNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get talkNext;

  /// No description provided for @talkPrevious.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get talkPrevious;

  /// No description provided for @talkCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Great voice!'**
  String get talkCompleteTitle;

  /// No description provided for @talkCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You talked through every page.'**
  String get talkCompleteMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
