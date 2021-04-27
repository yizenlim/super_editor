import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class DemoOndemandMarkdownSerializationEditor extends StatefulWidget {
  @override
  _DemoOndemandMarkdownSerializationEditorState createState() =>
      _DemoOndemandMarkdownSerializationEditorState();
}

class _DemoOndemandMarkdownSerializationEditorState
    extends State<DemoOndemandMarkdownSerializationEditor> {
  Document _doc;
  DocumentEditor _docEditor;
  String _markdown = '';

  @override
  void initState() {
    super.initState();
    _doc = MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sed sagittis urna. Aenean mattis ante justo, quis sollicitudin metus interdum id. Aenean ornare urna ac enim consequat mollis. In aliquet convallis efficitur. Phasellus convallis purus in fringilla scelerisque. Ut ac orci a turpis egestas lobortis. Morbi aliquam dapibus sem, vitae sodales arcu ultrices eu. Duis vulputate mauris quam, eleifend pulvinar quam blandit eget.',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _docEditor = _markdown.isEmpty
        ? DocumentEditor(document: _doc)
        : DocumentEditor(document: deserializeMarkdownToDocument(_markdown));
    return Column(
      children: [
        Expanded(
          child: Editor.standard(
            editor: _docEditor,
            maxWidth: 600,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _markdown = serializeDocumentToMarkdown(_docEditor.document);
                    print('markdown $_markdown');
                  },
                  child: SizedBox(
                    height: 36,
                    child: Center(child: Text('Save')),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: SizedBox(
                    height: 36,
                    child: Center(child: Text('Update')),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
