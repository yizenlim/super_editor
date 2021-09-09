import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

void main() {
  runApp(
    MaterialApp(
      home: MarketingVideo(),
    ),
  );
}

class MarketingVideo extends StatefulWidget {
  @override
  _MarketingVideoState createState() => _MarketingVideoState();
}

class _MarketingVideoState extends State<MarketingVideo> {
  final _docLayoutKey = GlobalKey();
  late DocumentEditor _editor;
  DocumentComposer? _composer;

  @override
  void initState() {
    super.initState();

    final doc = MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: ''),
        ),
      ],
    );
    _editor = DocumentEditor(document: doc);
    _composer = DocumentComposer(
        initialSelection: DocumentSelection.collapsed(
      position: DocumentPosition(
        nodeId: doc.nodes.first.id,
        nodePosition: doc.nodes.first.endPosition,
      ),
    ));

    _startRobot();
  }

  @override
  void dispose() {
    _composer!.dispose();
    super.dispose();
  }

  Future<void> _startRobot() async {
    final robot = DocumentEditingRobot(
      editor: _editor,
      composer: _composer!,
      documentLayoutFinder: () => _docLayoutKey.currentState as DocumentLayout?,
    );

    robot
      ..pause(const Duration(seconds: 20))
      ..typeText('🔥')
      ..pause(const Duration(seconds: 5))
      ..backspace();
    await robot.start();

    // TODO: fix bug here. If we use select all to select the emoji
    //       and delete, the resulting selection is wrong
    // robot
    //   ..selectAll()
    //   ..backspace();
    // await robot.start();

    robot
      ..pause(const Duration(seconds: 3))
      ..typeText('Introducing')
      ..pause(const Duration(milliseconds: 500))
      ..newline()
      ..addAttribution(titleAttribution)
      ..typeText('A new Flutter text Editor')
      ..pause(const Duration(seconds: 2))
      ..moveCaretLeft(count: 7)
      ..pause(const Duration(milliseconds: 250))
      ..moveCaretLeft(count: 18, expand: true)
      ..pause(const Duration(milliseconds: 1000))
      // TODO: this is a hack because _updateComposerPreferencesAtSelection is
      //       clearing out the current style when it shouldn't be
      ..addAttribution(titleAttribution)
      ..addAttribution(superlistBrandAttribution)
      ..typeText('Super')
      ..removeAttribution(superlistBrandAttribution)
      ..removeAttribution(titleAttribution)
      ..pause(const Duration(seconds: 1))
      ..moveCaretRight(count: 8)
      ..newline()
      ..newline()
      ..addAttribution(headerAttribution)
      ..typeText('v0.1.0')
      ..removeAttribution(headerAttribution)
      ..pause(const Duration(milliseconds: 2000))
      ..newline()
      ..typeText('https://rb.gy/ksykan')
      ..typeText(' ') // a space to convert the image
      ..pause(const Duration(seconds: 2))
      ..newline()
      ..newline()
      ..typeText(' * ')
      ..addAttribution(boldAttribution)
      ..typeText('bold')
      ..removeAttribution(boldAttribution)
      ..typeText(' text')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..addAttribution(italicsAttribution)
      ..typeText('italic')
      ..removeAttribution(italicsAttribution)
      ..typeText(' text')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..addAttribution(strikethroughAttribution)
      ..typeText('strikethrough')
      ..removeAttribution(strikethroughAttribution)
      ..typeText(' text')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..backspace()
      ..newline()
      ..typeText('> Blockquotes, too')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..newline()
      ..typeText(' * unordered lists')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..typeText('also')
      ..newline()
      ..backspace()
      ..newline()
      ..typeText(' 1. ordered')
      ..newline()
      ..typeText('lists')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..backspace()
      ..newline()
      ..typeText(' * horizontal rules')
      ..pause(const Duration(milliseconds: 500))
      ..newline()
      ..backspace()
      ..newline()
      ..typeText('--- ')
      ..typeText(' ')
      ..pause(const Duration(milliseconds: 1000))
      ..newline()
      ..typeText('and')
      ..pause(const Duration(milliseconds: 500))
      ..typeText('.')
      ..pause(const Duration(milliseconds: 500))
      ..typeText('.')
      ..pause(const Duration(milliseconds: 500))
      ..typeText('.')
      ..newline()
      ..newline()
      ..pause(const Duration(milliseconds: 1000))
      ..typeText("WE'RE.")
      ..newline()
      ..pause(const Duration(milliseconds: 500))
      ..typeText('JUST.')
      ..newline()
      ..pause(const Duration(milliseconds: 500))
      ..typeText('GETTING.')
      ..newline()
      ..pause(const Duration(milliseconds: 500))
      ..addAttribution(boldAttribution)
      ..typeText('STARTED!')
      ..removeAttribution(boldAttribution)
      ..pause(const Duration(milliseconds: 1000))
      ..typeTextFast(
          '🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 ')
      ..typeTextFast(
          '🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 ')
      ..typeTextFast(
          '🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 🚀 ');

    await robot.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 48),
        child: SuperEditor.custom(
          documentLayoutKey: _docLayoutKey,
          editor: _editor,
          composer: _composer,
          textStyleBuilder: _textStyleBuilder,
          componentVerticalSpacing: 0,
        ),
      ),
    );
  }
}

TextStyle _textStyleBuilder(Set<Attribution> attributions) {
  TextStyle textStyle = defaultStyleBuilder(attributions).copyWith(
    fontSize: 18,
  );

  if (attributions.contains(titleAttribution)) {
    textStyle = textStyle.copyWith(
      fontSize: 24,
    );
  }

  if (attributions.contains(headerAttribution)) {
    textStyle = textStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }

  if (attributions.contains(superlistBrandAttribution)) {
    textStyle = textStyle.copyWith(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );
  }

  return textStyle;
}

const superlistBrandAttribution = NamedAttribution('superlist_brand');
const titleAttribution = NamedAttribution('titleAttribution');
const headerAttribution = NamedAttribution('header');

class DocumentEditingRobot {
  DocumentEditingRobot({
    required DocumentEditor editor,
    required DocumentComposer composer,
    required DocumentLayoutFinder documentLayoutFinder,
    int? randomSeed,
  })  : _editor = editor,
        _composer = composer,
        _editorOps = CommonEditorOperations(
            editor: editor,
            composer: composer,
            documentLayoutResolver: documentLayoutFinder as DocumentLayout Function()),
        _random = Random(randomSeed);

  final DocumentEditor _editor;
  final DocumentComposer _composer;
  final CommonEditorOperations _editorOps;
  final _actionQueue = <RobotAction>[];
  final Random _random;

  void placeCaret(DocumentPosition position) {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _composer.selection = DocumentSelection.collapsed(position: position);
        },
      ),
    );
  }

  void select(DocumentSelection selection) {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _composer.selection = selection;
        },
      ),
    );
  }

  void selectAll() {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _composer.selection = DocumentSelection(
            base: DocumentPosition(
              nodeId: _editor.document.nodes.first.id,
              nodePosition: _editor.document.nodes.first.beginningPosition,
            ),
            extent: DocumentPosition(
              nodeId: _editor.document.nodes.last.id,
              nodePosition: _editor.document.nodes.last.endPosition,
            ),
          );
        },
      ),
    );
  }

  void moveCaretLeft({
    int count = 1,
    bool expand = false,
  }) {
    for (int i = 0; i < count; ++i) {
      _actionQueue.add(
        _randomPauseBefore(
          () {
            _editorOps.moveCaretUpstream(expand: expand);
          },
        ),
      );
    }
  }

  void moveCaretRight({
    int count = 1,
    bool expand = false,
  }) {
    for (int i = 0; i < count; ++i) {
      _actionQueue.add(
        _randomPauseBefore(
          () {
            _editorOps.moveCaretDownstream(expand: expand);
          },
        ),
      );
    }
  }

  void moveCaretUp({expand = false}) {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.moveCaretUp(expand: expand);
        },
      ),
    );
  }

  void moveCaretDown({expand = false}) {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.moveCaretDown(expand: expand);
        },
      ),
    );
  }

  void typeText(String text) {


    for (final character in text.characters) {
      _actionQueue.add(
        _randomPauseBefore(
          () {
            _editorOps.insertCharacter(character);

            if (character == ' ') {
              _editorOps.convertParagraphByPatternMatching(_composer.selection!.extent.nodeId);
            }
          },
        ),
      );
    }
  }

  void typeTextFast(String text) {
    for (final character in text.characters) {
      _actionQueue.add(
        _randomPauseBefore(
          () {
            _editorOps.insertCharacter(character);

            if (character == ' ') {
              _editorOps.convertParagraphByPatternMatching(_composer.selection!.extent.nodeId);
            }
          },
          true,
        ),
      );
    }
  }

  void addAttribution(Attribution attribution) {
    _actionQueue.add(() {
      _composer.preferences.addStyle(attribution);
    });
  }

  void removeAttribution(Attribution attribution) {
    _actionQueue.add(() {
      _composer.preferences.removeStyle(attribution);
    });
  }

  void newline() {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.insertBlockLevelNewline();
        },
      ),
    );
  }

  void backspace() {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.deleteUpstream();
        },
      ),
    );
  }

  void delete() {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.deleteDownstream();
        },
      ),
    );
  }

  void paste(String text) {
    _actionQueue.add(
      _randomPauseBefore(
        () {
          _editorOps.insertPlainText(text);
        },
      ),
    );
  }

  void pause(Duration duration) {
    _actionQueue.add(
      () async {
        await Future.delayed(duration);
      },
    );
  }

  RobotAction _randomPauseBefore(RobotAction action, [bool fastMode = false]) {
    return () async {
      await Future.delayed(_randomWaitPeriod(fastMode));
      await action();
    };
  }

  Duration _randomWaitPeriod([bool fastMode = false]) {
    return Duration(milliseconds: _random.nextInt(fastMode ? 45 : 200) + (fastMode ? 5 : 50));
  }

  Future<void> start() async {
    while (_actionQueue.isNotEmpty) {
      final action = _actionQueue.removeAt(0);
      await action();
    }
  }

  Future<void> cancel() async {
    _actionQueue.clear();
  }
}

typedef RobotAction = FutureOr<void> Function();

typedef DocumentLayoutFinder = DocumentLayout? Function();
