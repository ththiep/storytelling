// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Kể chuyện';

  @override
  String get homeTitle => 'Góc kể chuyện';

  @override
  String loadStoriesError(String message) {
    return 'Ôi, chưa tải được truyện: $message';
  }

  @override
  String get hubQuestion => 'Con muốn làm gì?';

  @override
  String get readStoryTitle => 'Đọc truyện';

  @override
  String get readStorySubtitle => 'Nghe và đọc từng từ';

  @override
  String get readStoryAction => 'Bắt đầu';

  @override
  String get playTitle => 'Chơi';

  @override
  String get playSubtitle => 'Xếp hình đúng thứ tự';

  @override
  String get playAction => 'Chơi ngay';

  @override
  String get speakTitle => 'Luyện nói';

  @override
  String get speakSubtitle => 'Đọc to cho cả nhà nghe';

  @override
  String get speakAction => 'Nói ngay';

  @override
  String get comingSoon => 'Sắp có';

  @override
  String minutesCount(int count) {
    return '$count phút';
  }

  @override
  String pagesCount(int count) {
    return '$count trang';
  }

  @override
  String readerPageCount(int current, int total) {
    return 'Trang $current/$total';
  }

  @override
  String readerError(String message) {
    return 'Ôi: $message';
  }

  @override
  String get readerFinishedStatus => 'Con đọc xong rồi!';

  @override
  String get readerSpeakingStatus => 'Đang kể...';

  @override
  String get readerPausedStatus => 'Tạm dừng';

  @override
  String get readerIdleStatus => 'Bấm để nghe';

  @override
  String get autoTurnPage => 'Tự lật trang';

  @override
  String get finishReading => 'Đọc xong';

  @override
  String get completionTitle => 'Giỏi quá!';

  @override
  String completionMessage(String title) {
    return 'Con đã nghe xong\n\"$title\"';
  }

  @override
  String get listenAgainQuestion => 'Nghe lại nhé?';

  @override
  String get listenAgainAction => 'Nghe từ đầu';

  @override
  String get playGameQuestion => 'Chơi trò chơi nhé?';

  @override
  String get playGameAction => 'Chơi cùng truyện';

  @override
  String get gameSubtitle => 'Xếp hình theo trang';

  @override
  String get gameCompleteTitle => 'Xong rồi!';

  @override
  String get gameCompleteMessage => 'Con xếp đúng hình rồi!';

  @override
  String get puzzleNoPictures => 'Truyện này chưa có hình để chơi.';

  @override
  String get puzzleSolved => 'Hay quá! Con xếp đúng rồi.';

  @override
  String get puzzleInstructions =>
      'Chạm chọn hình, rồi chạm vào ô trang.\nCon cũng có thể kéo hình.';

  @override
  String get puzzleSelected => 'Đã chọn hình. Chạm vào ô trang nhé.';

  @override
  String get puzzlePiecesTitle => 'Các hình';

  @override
  String get shuffleAgain => 'Xáo lại';

  @override
  String pageLabel(int number) {
    return 'Trang $number';
  }

  @override
  String talkPageCount(int current, int total) {
    return 'Trang $current/$total';
  }

  @override
  String get talkEmpty => 'Truyện này chưa có chữ để luyện nói.';

  @override
  String get talkReadyStatus => 'Sẵn sàng chưa?';

  @override
  String get talkListeningStatus => 'Cô đang nghe...';

  @override
  String get talkDoneStatus => 'Con đọc hay lắm!';

  @override
  String get talkStart => 'Bắt đầu';

  @override
  String get talkStop => 'Xong rồi';

  @override
  String get talkRecordAgain => 'Ghi lại';

  @override
  String get talkPlayRecording => 'Nghe lại';

  @override
  String get talkRecordingError => 'Ôi, chưa ghi được. Thử lại nhé.';

  @override
  String get talkPlaybackError => 'Ôi, chưa nghe lại được.';

  @override
  String get talkNext => 'Tiếp';

  @override
  String get talkPrevious => 'Lùi lại';

  @override
  String get talkCompleteTitle => 'Giọng hay quá!';

  @override
  String get talkCompleteMessage => 'Con đã đọc hết các trang rồi.';
}
