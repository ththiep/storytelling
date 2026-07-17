import 'dart:math';

import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/app/theme/theme_manager.dart';
import 'package:storytelling/core/logging/app_logger.dart';
import 'package:storytelling/l10n/app_localizations.dart';
import 'package:storytelling/shared/widgets/story_image.dart';

class PagePuzzlePiece {
  const PagePuzzlePiece({required this.pageIndex, required this.imageUrl});

  final int pageIndex;
  final String imageUrl;
}

class PageOrderPuzzleGame extends StatefulWidget {
  const PageOrderPuzzleGame({
    super.key,
    required this.pieces,
    this.onCompleted,
  });

  final List<PagePuzzlePiece> pieces;
  final VoidCallback? onCompleted;

  @override
  State<PageOrderPuzzleGame> createState() => _PageOrderPuzzleGameState();
}

class _PageOrderPuzzleGameState extends State<PageOrderPuzzleGame> {
  late List<int> _poolPieceIndices;
  late List<int?> _slotPieceIndices;
  int? _selectedPieceIndex;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _resetPuzzle();
  }

  void _resetPuzzle() {
    final count = widget.pieces.length;
    AppLogger.info('play.puzzle', 'Reset puzzle pieces=$count');
    _slotPieceIndices = List<int?>.filled(count, null);
    _poolPieceIndices = List<int>.generate(count, (index) => index);
    _poolPieceIndices.shuffle(Random());
    _selectedPieceIndex = null;
    _isSolved = false;

    if (count == 1) {
      AppLogger.info('play.puzzle', 'Single-piece puzzle auto-solved');
      _slotPieceIndices[0] = _poolPieceIndices.removeAt(0);
      _isSolved = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCompleted?.call();
      });
    }
  }

  void _selectPiece(int pieceIndex) {
    if (_isSolved) return;
    setState(() {
      _selectedPieceIndex = _selectedPieceIndex == pieceIndex
          ? null
          : pieceIndex;
    });
  }

  void _placeSelectedIntoSlot(int slotIndex) {
    final selected = _selectedPieceIndex;
    if (selected == null || _isSolved) return;
    _placePieceInSlot(pieceIndex: selected, slotIndex: slotIndex);
  }

  void _placePieceInSlot({required int pieceIndex, required int slotIndex}) {
    if (_isSolved) return;

    setState(() {
      final previousInSlot = _slotPieceIndices[slotIndex];
      final selectedSourceSlot = _slotPieceIndices.indexOf(pieceIndex);

      if (selectedSourceSlot >= 0) {
        _slotPieceIndices[selectedSourceSlot] = previousInSlot;
      } else {
        _poolPieceIndices.remove(pieceIndex);
        if (previousInSlot != null) {
          _poolPieceIndices.add(previousInSlot);
        }
      }

      _slotPieceIndices[slotIndex] = pieceIndex;
      _selectedPieceIndex = null;
      _checkSolved();
    });
  }

  void _returnSlotPieceToPool(int slotIndex) {
    final pieceIndex = _slotPieceIndices[slotIndex];
    if (pieceIndex == null || _isSolved) return;

    setState(() {
      _slotPieceIndices[slotIndex] = null;
      if (!_poolPieceIndices.contains(pieceIndex)) {
        _poolPieceIndices.add(pieceIndex);
      }
      if (_selectedPieceIndex == pieceIndex) {
        _selectedPieceIndex = null;
      }
      _isSolved = false;
    });
  }

  void _checkSolved() {
    if (_slotPieceIndices.any((pieceIndex) => pieceIndex == null)) return;

    final solved = _slotPieceIndices.asMap().entries.every((entry) {
      final piece = widget.pieces[entry.value!];
      return piece.pageIndex == entry.key;
    });

    if (!solved) return;

    AppLogger.info(
      'play.puzzle',
      'Puzzle solved pieces=${widget.pieces.length}',
    );
    _isSolved = true;
    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    if (widget.pieces.isEmpty) {
      return Center(
        child: Text(
          l10n.puzzleNoPictures,
          textAlign: TextAlign.center,
          style: theme.bodyMedium.copyWith(color: theme.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            _isSolved
                ? l10n.puzzleSolved
                : _selectedPieceIndex == null
                ? l10n.puzzleInstructions
                : l10n.puzzleSelected,
            textAlign: TextAlign.center,
            style: theme.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: _isSolved ? theme.playColor : theme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _PuzzleBoard(
              pieces: widget.pieces,
              slotPieceIndices: _slotPieceIndices,
              selectedPieceIndex: _selectedPieceIndex,
              isSolved: _isSolved,
              onSlotTapped: _placeSelectedIntoSlot,
              onFilledSlotTapped: (slotIndex, pieceIndex) {
                if (_selectedPieceIndex != null) {
                  _placePieceInSlot(
                    pieceIndex: _selectedPieceIndex!,
                    slotIndex: slotIndex,
                  );
                } else {
                  _selectPiece(pieceIndex);
                }
              },
              onFilledSlotDoubleTapped: _returnSlotPieceToPool,
              onPieceDropped: ({required pieceIndex, required slotIndex}) {
                _placePieceInSlot(pieceIndex: pieceIndex, slotIndex: slotIndex);
              },
            ),
          ),
        ),
        if (!_isSolved) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.puzzlePiecesTitle,
                style: theme.caption.copyWith(color: theme.textSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                for (final pieceIndex in _poolPieceIndices)
                  _PuzzlePieceChip(
                    piece: widget.pieces[pieceIndex],
                    pieceIndex: pieceIndex,
                    isSelected: _selectedPieceIndex == pieceIndex,
                    onTap: () => _selectPiece(pieceIndex),
                  ),
              ],
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextButton.icon(
            onPressed: _resetPuzzle,
            icon: const Icon(Icons.shuffle_rounded),
            label: Text(l10n.shuffleAgain),
          ),
        ),
      ],
    );
  }
}

class _PuzzleBoard extends StatelessWidget {
  const _PuzzleBoard({
    required this.pieces,
    required this.slotPieceIndices,
    required this.selectedPieceIndex,
    required this.isSolved,
    required this.onSlotTapped,
    required this.onFilledSlotTapped,
    required this.onFilledSlotDoubleTapped,
    required this.onPieceDropped,
  });

  final List<PagePuzzlePiece> pieces;
  final List<int?> slotPieceIndices;
  final int? selectedPieceIndex;
  final bool isSolved;
  final ValueChanged<int> onSlotTapped;
  final void Function(int slotIndex, int pieceIndex) onFilledSlotTapped;
  final ValueChanged<int> onFilledSlotDoubleTapped;
  final void Function({required int pieceIndex, required int slotIndex})
  onPieceDropped;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return DecoratedBox(
      decoration: theme.storyCardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            for (var slotIndex = 0; slotIndex < pieces.length; slotIndex++)
              Expanded(
                child: _PuzzleSlot(
                  slotIndex: slotIndex,
                  pieceIndex: slotPieceIndices[slotIndex],
                  piece: slotPieceIndices[slotIndex] == null
                      ? null
                      : pieces[slotPieceIndices[slotIndex]!],
                  isSelected:
                      slotPieceIndices[slotIndex] != null &&
                      slotPieceIndices[slotIndex] == selectedPieceIndex,
                  isSolved: isSolved,
                  showDivider: slotIndex < pieces.length - 1 && !isSolved,
                  onEmptyTapped: () => onSlotTapped(slotIndex),
                  onFilledTapped: (pieceIndex) {
                    onFilledSlotTapped(slotIndex, pieceIndex);
                  },
                  onFilledDoubleTapped: () =>
                      onFilledSlotDoubleTapped(slotIndex),
                  onPieceDropped: (pieceIndex) {
                    onPieceDropped(
                      pieceIndex: pieceIndex,
                      slotIndex: slotIndex,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PuzzleSlot extends StatelessWidget {
  const _PuzzleSlot({
    required this.slotIndex,
    required this.pieceIndex,
    required this.piece,
    required this.isSelected,
    required this.isSolved,
    required this.showDivider,
    required this.onEmptyTapped,
    required this.onFilledTapped,
    required this.onFilledDoubleTapped,
    required this.onPieceDropped,
  });

  final int slotIndex;
  final int? pieceIndex;
  final PagePuzzlePiece? piece;
  final bool isSelected;
  final bool isSolved;
  final bool showDivider;
  final VoidCallback onEmptyTapped;
  final ValueChanged<int> onFilledTapped;
  final VoidCallback onFilledDoubleTapped;
  final ValueChanged<int> onPieceDropped;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);
    final isCorrect =
        piece != null && piece!.pageIndex == slotIndex && !isSolved;
    final isWrong = piece != null && piece!.pageIndex != slotIndex;

    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => !isSolved,
      onAcceptWithDetails: (details) => onPieceDropped(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;

        return Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: isSolved
                ? null
                : () {
                    if (pieceIndex == null) {
                      onEmptyTapped();
                    } else {
                      onFilledTapped(pieceIndex!);
                    }
                  },
            onDoubleTap: isSolved || pieceIndex == null
                ? null
                : onFilledDoubleTapped,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: piece == null
                    ? (isHighlighted ? AppColors.brand100 : AppColors.brand50)
                    : AppColors.transparent,
                border: isSolved
                    ? null
                    : Border.all(
                        color: isWrong
                            ? theme.error
                            : isCorrect
                            ? theme.success
                            : isSelected || isHighlighted
                            ? theme.playColor
                            : AppColors.borderDefault,
                        width: isSelected || isHighlighted ? 2.5 : 1.2,
                      ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (piece != null && pieceIndex != null)
                    Draggable<int>(
                      data: pieceIndex,
                      maxSimultaneousDrags: isSolved ? 0 : 1,
                      feedback: Material(
                        elevation: 8,
                        borderRadius: theme.radiusLarge,
                        child: SizedBox(
                          width: 180,
                          height: 100,
                          child: _PuzzlePieceImage(
                            piece: piece!,
                            showPageLabel: true,
                            borderRadius: theme.radiusLarge,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.25,
                        child: _PuzzlePieceImage(
                          piece: piece!,
                          showPageLabel: !isSolved,
                        ),
                      ),
                      child: _PuzzlePieceImage(
                        piece: piece!,
                        showPageLabel: !isSolved,
                        isSelected: isSelected,
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.extension_rounded,
                            color: theme.playColor.withValues(alpha: 0.45),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.pageLabel(slotIndex + 1),
                            style: theme.bodySmall.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showDivider)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.borderDefault,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PuzzlePieceChip extends StatelessWidget {
  const _PuzzlePieceChip({
    required this.piece,
    required this.pieceIndex,
    required this.isSelected,
    required this.onTap,
  });

  final PagePuzzlePiece piece;
  final int pieceIndex;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Draggable<int>(
      data: pieceIndex,
      feedback: Material(
        elevation: 8,
        borderRadius: theme.radiusLarge,
        child: SizedBox(
          width: 110,
          height: 110,
          child: _PuzzlePieceImage(
            piece: piece,
            showPageLabel: true,
            borderRadius: theme.radiusLarge,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: SizedBox(
          width: 96,
          height: 96,
          child: _PuzzlePieceImage(
            piece: piece,
            showPageLabel: true,
            borderRadius: theme.radiusLarge,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: theme.radiusLarge,
            border: Border.all(
              color: isSelected ? theme.playColor : AppColors.transparent,
              width: 3,
            ),
            boxShadow: theme.cardShadow,
          ),
          child: _PuzzlePieceImage(
            piece: piece,
            showPageLabel: true,
            borderRadius: BorderRadius.circular(13),
            isSelected: isSelected,
          ),
        ),
      ),
    );
  }
}

class _PuzzlePieceImage extends StatelessWidget {
  const _PuzzlePieceImage({
    required this.piece,
    required this.showPageLabel,
    this.borderRadius,
    this.isSelected = false,
  });

  final PagePuzzlePiece piece;
  final bool showPageLabel;
  final BorderRadius? borderRadius;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        StoryImage(
          imageUrl: piece.imageUrl,
          fit: BoxFit.cover,
          borderRadius: borderRadius,
        ),
        if (showPageLabel)
          Positioned(
            left: 8,
            top: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.black10,
                borderRadius: theme.radiusSmall,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  l10n.pageLabel(piece.pageIndex + 1),
                  style: theme.caption.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
        if (isSelected)
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: theme.playColor, width: 2),
            ),
          ),
      ],
    );
  }
}
