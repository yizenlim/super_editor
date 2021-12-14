import 'package:flutter/rendering.dart';
import 'package:characters/characters.dart';

/// Contract to interrogate the layout of a blob of text.
abstract class TextLayout {
  /// Returns [true] if a text character overlaps the given [localOffset],
  /// or [false] otherwise.
  bool isTextAtOffset(Offset localOffset);

  /// Returns the [TextPosition] that overlaps the given [localOffset].
  TextPosition? getPositionAtOffset(Offset localOffset);

  /// Returns the [TextPosition] that overlaps the given [localOffset],
  /// or the [TextPosition] that is nearest the given [localOffset] if
  /// no [TextPosition] overlaps the given [localOffset].
  TextPosition getPositionNearestToOffset(Offset localOffset);

  /// Returns the [Offset] of the character at the given [position].
  Offset getOffsetAtPosition(TextPosition position);

  /// Returns a [List] of [TextBox]es that contain the given [selection].
  List<TextBox> getBoxesForSelection(TextSelection selection);

  /// Returns a bounding [TextBox] for the character at the given [position].
  TextBox getCharacterBox(TextPosition position);

  /// Returns the [TextPosition] that corresponds to a text location
  /// that is one line above the given [textPosition], or [null] if
  /// there is no position one line up.
  TextPosition? getPositionOneLineUp(TextPosition textPosition);

  /// Returns the [TextPosition] that corresponds to a text location
  /// that is one line below the given [textPosition], or [null] if
  /// there is no position one line down.
  TextPosition? getPositionOneLineDown(TextPosition textPosition);

  /// Returns the [TextPosition] that corresponds to the first character
  /// in the line of text that contains the given [textPosition].
  TextPosition getPositionAtStartOfLine(TextPosition textPosition);

  /// Returns the [TextPosition] that corresponds to the last character
  /// in the line of text that contains the given [textPosition].
  TextPosition getPositionAtEndOfLine(TextPosition textPosition);

  /// Returns the `TextPosition` in the first line within this
  /// `TextLayout` that is closest to the given `x`-value, or
  /// -1 if the text is not laid out yet.
  TextPosition getPositionInFirstLineAtX(double x);

  /// Returns the `TextPosition` in the last line within this
  /// `TextLayout` that is closest to the given `x`-value, or
  /// -1 if the text is not laid out yet.
  TextPosition getPositionInLastLineAtX(double x);

  /// Returns the `TextSelection` that corresponds to a selection
  /// rectangle formed by the span from `baseOffset` to `extentOffset`, or
  /// a collapsed selection at -1 if the text is not laid out yet.
  ///
  /// The `baseOffset` determines where the selection begins. The
  /// `extentOffset` determines where the selection ends.
  TextSelection getSelectionInRect(Offset baseOffset, Offset extentOffset);

  /// Returns a [TextSelection] that surrounds the given [startingPosition] and expands
  /// outward until the given [expansion] chooses to stop expanding.
  TextSelection expandSelection(TextPosition startingPosition, TextExpansion expansion, TextAffinity affinity);
}

typedef TextExpansion = TextSelection Function(String text, TextPosition startingPosition, TextAffinity affinity);

TextSelection paragraphExpansionFilter(String text, TextPosition startingPosition, TextAffinity affinity) {
  // If the given position falls directly on a newline then return
  // just the newline character as the paragraph selection.
  if (startingPosition.offset < text.length && text[startingPosition.offset] == '\n') {
    return TextSelection.collapsed(offset: startingPosition.offset);
  }

  int start = startingPosition.offset;
  int end = startingPosition.offset;

  while (start > 0 && text[start - 1] != '\n') {
    start -= 1;
  }
  while (end < text.length && text[end] != '\n') {
    end += 1;
  }

  return affinity == TextAffinity.downstream
      ? TextSelection(
          baseOffset: start,
          extentOffset: end,
        )
      : TextSelection(
          baseOffset: end,
          extentOffset: start,
        );
}

/// Returns the code point index for the code point that ends the visual
/// character that begins at [startingCodePointIndex].
///
/// A single visual character might be comprised of multiple code points.
/// Each code point occupies a slot within a [String], which means that
/// an index into a [String] might refer to a piece of a single visual
/// character.
///
/// [startingCodePointIndex] is the traditional [String] index for the
/// leading code point of a visual character.
///
/// This function starts at the given [startingCodePointIndex] and walks
/// towards the end of [text] until it has accumulated an entire
/// visual character. The [String] index of the final code point for
/// the given character is returned.
int getCharacterEndBounds(String text, int startingCodePointIndex) {
  assert(startingCodePointIndex >= 0 && startingCodePointIndex <= text.length);

  // TODO: copy the implementation of nextCharacter to this package because
  //       it's marked as visible for testing
  final startOffset = nextCharacter(startingCodePointIndex, text);
  return startOffset;
}

/// Returns the code point index for the code point that begins the visual
/// character that ends at [endingCodePointIndex].
///
/// A single visual character might be comprised of multiple code points.
/// Each code point occupies a slot within a [String], which means that
/// an index into a [String] might refer to a piece of a single visual
/// character.
///
/// [endingCodePointIndex] is the traditional [String] index for the
/// trailing code point of a visual character.
///
/// This function starts at the given [endingCodePointIndex] and walks
/// towards the beginning of [text] until it has accumulated an entire
/// visual character. The [String] index of the initial code point for
/// the given character is returned.
int getCharacterStartBounds(String text, int endingCodePointIndex) {
  assert(endingCodePointIndex >= 0 && endingCodePointIndex <= text.length);

  // TODO: copy the implementation of previousCharacter to this package because
  //       it's marked as visible for testing
  final startOffset = previousCharacter(endingCodePointIndex, text);
  return startOffset;
}




/// Returns the index into the string of the next character boundary after the
/// given index.
///
/// The character boundary is determined by the characters package, so
/// surrogate pairs and extended grapheme clusters are considered.
///
/// The index must be between 0 and string.length, inclusive. If given
/// string.length, string.length is returned.
///
/// Setting includeWhitespace to false will only return the index of non-space
/// characters.
 int nextCharacter(int index, String string, [bool includeWhitespace = true]) {
assert(index >= 0 && index <= string.length);
if (index == string.length) {
return string.length;
}

int count = 0;
final Characters remaining = string.characters.skipWhile((String currentString) {
if (count <= index) {
count += currentString.length;
return true;
}
if (includeWhitespace) {
return false;
}
return _isWhitespace(currentString.codeUnitAt(0));
});
return string.length - remaining.toString().length;
}

/// Returns the index into the string of the previous character boundary
/// before the given index.
///
/// The character boundary is determined by the characters package, so
/// surrogate pairs and extended grapheme clusters are considered.
///
/// The index must be between 0 and string.length, inclusive. If index is 0,
/// 0 will be returned.
///
/// Setting includeWhitespace to false will only return the index of non-space
/// characters.

 int previousCharacter(int index, String string, [bool includeWhitespace = true]) {
assert(index >= 0 && index <= string.length);
if (index == 0) {
return 0;
}

int count = 0;
int? lastNonWhitespace;
for (final String currentString in string.characters) {
if (!includeWhitespace &&
!_isWhitespace(currentString.characters.first.codeUnitAt(0))) {
lastNonWhitespace = count;
}
if (count + currentString.length >= index) {
return includeWhitespace ? count : lastNonWhitespace ?? 0;
}
count += currentString.length;
}
return 0;
}

bool _isWhitespace(int codeUnit) {
  switch (codeUnit) {
    case 0x9: // horizontal tab
    case 0xA: // line feed
    case 0xB: // vertical tab
    case 0xC: // form feed
    case 0xD: // carriage return
    case 0x1C: // file separator
    case 0x1D: // group separator
    case 0x1E: // record separator
    case 0x1F: // unit separator
    case 0x20: // space
    case 0xA0: // no-break space
    case 0x1680: // ogham space mark
    case 0x2000: // en quad
    case 0x2001: // em quad
    case 0x2002: // en space
    case 0x2003: // em space
    case 0x2004: // three-per-em space
    case 0x2005: // four-er-em space
    case 0x2006: // six-per-em space
    case 0x2007: // figure space
    case 0x2008: // punctuation space
    case 0x2009: // thin space
    case 0x200A: // hair space
    case 0x202F: // narrow no-break space
    case 0x205F: // medium mathematical space
    case 0x3000: // ideographic space
      break;
    default:
      return false;
  }
  return true;
}


