import 'package:super_editor/src/infrastructure/attributed_spans.dart';

/// Header 1 style attribution.
const header1Attribution = NamedAttribution('header1');

/// Header 2 style attribution.
const header2Attribution = NamedAttribution('header2');

/// Header 3 style attribution.
const header3Attribution = NamedAttribution('header3');

/// Header 4 style attribution.
const header4Attribution = NamedAttribution('header4');

/// Header 5 style attribution.
const header5Attribution = NamedAttribution('header5');

/// Header 6 style attribution.
const header6Attribution = NamedAttribution('header6');

/// Blockquote attribution
const blockquoteAttribution = NamedAttribution('blockquote');

/// Bold style attribution.
const boldAttribution = NamedAttribution('bold');

/// Italics style attribution.
const italicsAttribution = NamedAttribution('italics');

/// Italics style attribution.
const underlineAttribution = NamedAttribution('underline');

/// Strikethrough style attribution.
const strikethroughAttribution = NamedAttribution('strikethrough');

/// Code style attribution.
const codeAttribution = NamedAttribution('code');

/// Attribution to be used within [AttributedText] to
/// represent a link.
///
/// Every [LinkAttribution] is considered equivalent so
/// that [AttributedText] prevents multiple [LinkAttribution]s
/// from overlapping.
///
/// If [LinkAttribution] does not meet your development needs,
/// a different class or value can be used to implement links
/// within [AttributedText]. This class doesn't have a special
/// relationship with [AttributedText].
class LinkAttribution implements Attribution {
  LinkAttribution({
    required this.url,
  });

  @override
  String get id => 'link';

  final Uri url;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LinkAttribution && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return '[LinkAttribution]: $url';
  }
}
