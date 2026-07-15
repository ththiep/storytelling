import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/widgets/games/page_order_puzzle_game.dart';

void main() {
  test('PagePuzzlePiece stores page index and image url', () {
    const piece = PagePuzzlePiece(
      pageIndex: 1,
      imageUrl: 'assets/stories/too-big/page_2.png',
    );

    expect(piece.pageIndex, 1);
    expect(piece.imageUrl, contains('page_2.png'));
  });
}
