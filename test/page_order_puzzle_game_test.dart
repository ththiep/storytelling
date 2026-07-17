import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/features/play/presentation/widgets/page_order_puzzle_game.dart';

void main() {
  test('PagePuzzlePiece stores page index and image url', () {
    const piece = PagePuzzlePiece(
      pageIndex: 1,
      imageUrl: 'assets/stories/thanh-giong/pages/page_2.jpeg',
    );

    expect(piece.pageIndex, 1);
    expect(piece.imageUrl, contains('page_2.jpeg'));
  });
}
