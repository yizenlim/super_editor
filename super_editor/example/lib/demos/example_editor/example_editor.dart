import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '_example_document.dart';
import '_toolbar.dart';

/// Example of a rich text editor.
///
/// This editor will expand in functionality as package
/// capabilities expand.
class ExampleEditor extends StatefulWidget {
  @override
  _ExampleEditorState createState() => _ExampleEditorState();
}

class _ExampleEditorState extends State<ExampleEditor> {
  final GlobalKey _docLayoutKey = GlobalKey();

  late Document _doc;
  DocumentEditor? _docEditor;
  DocumentComposer? _composer;

  FocusNode? _editorFocusNode;

  ScrollController? _scrollController;

  OverlayEntry? _formatBarOverlayEntry;
  final _selectionAnchor = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();
    _doc = createEmptyDocument()..addListener(_hideOrShowToolbar);
    _docEditor = DocumentEditor(document: _doc as MutableDocument);
    _composer = DocumentComposer()..addListener(_hideOrShowToolbar);
    _editorFocusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_hideOrShowToolbar);
  }

  @override
  void dispose() {
    if (_formatBarOverlayEntry != null) {
      _formatBarOverlayEntry!.remove();
    }

    _scrollController!.dispose();
    _editorFocusNode!.dispose();
    _composer!.dispose();
    super.dispose();
  }

  void _hideOrShowToolbar() {
    final selection = _composer!.selection;
    if (selection == null) {
      // Nothing is selected. We don't want to show a toolbar
      // in this case.
      _hideEditorToolbar();

      return;
    }
    if (selection.base.nodeId != selection.extent.nodeId) {
      // More than one node is selected. We don't want to show
      // a toolbar in this case.
      _hideEditorToolbar();

      return;
    }
    if (selection.isCollapsed) {
      // We only want to show the toolbar when a span of text
      // is selected. Therefore, we ignore collapsed selections.
      _hideEditorToolbar();

      return;
    }

    final textNode = _doc.getNodeById(selection.extent.nodeId);
    if (textNode is! TextNode) {
      // The currently selected content is not a paragraph. We don't
      // want to show a toolbar in this case.
      _hideEditorToolbar();

      return;
    }

    // Show the editor's toolbar for text styling.
    _showEditorToolbar();
  }

  void _showEditorToolbar() {
    if (_formatBarOverlayEntry == null) {
      // Create an overlay entry to build the editor toolbar.
      // TODO: add an overlay to the Editor widget to avoid using the
      //       application overlay
      _formatBarOverlayEntry ??= OverlayEntry(builder: (context) {
        return EditorToolbar(
          anchor: _selectionAnchor,
          editor: _docEditor,
          composer: _composer,
          closeToolbar: _hideEditorToolbar,
        );
      });

      // Display the toolbar in the application overlay.
      final overlay = Overlay.of(context)!;
      overlay.insert(_formatBarOverlayEntry!);
    }

    // Schedule a callback after this frame to locate the selection
    // bounds on the screen and display the toolbar near the selected
    // text.
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_formatBarOverlayEntry == null) {
        return;
      }

      final docBoundingBox = (_docLayoutKey.currentState as DocumentLayout)
          .getRectForSelection(_composer!.selection!.base, _composer!.selection!.extent)!;
      final docBox = _docLayoutKey.currentContext!.findRenderObject() as RenderBox;
      final overlayBoundingBox = Rect.fromPoints(
        docBox.localToGlobal(docBoundingBox.topLeft, ancestor: context.findRenderObject()),
        docBox.localToGlobal(docBoundingBox.bottomRight, ancestor: context.findRenderObject()),
      );

      _selectionAnchor.value = overlayBoundingBox.topCenter;
    });
  }

  void _hideEditorToolbar() {
    // Null out the selection anchor so that when it re-appears,
    // the bar doesn't momentarily "flash" at its old anchor position.
    _selectionAnchor.value = null;

    if (_formatBarOverlayEntry != null) {
      // Remove the toolbar overlay and null-out the entry.
      // We null out the entry because we can't query whether
      // or not the entry exists in the overlay, so in our
      // case, null implies the entry is not in the overlay,
      // and non-null implies the entry is in the overlay.
      _formatBarOverlayEntry!.remove();
      _formatBarOverlayEntry = null;
    }

    // Ensure that focus returns to the editor.
    //
    // I tried explicitly unfocus()'ing the URL textfield
    // in the toolbar but it didn't return focus to the
    // editor. I'm not sure why.
    _editorFocusNode!.requestFocus();
  }
  late ScrollPhysics scrollPhysicsForParent= ClampingScrollPhysics();
  @override
  Widget build(BuildContext context) {
    print('nodes ${_doc.nodes}');


    return MouseRegion(

      child: Container(
        color : Colors.blue[300],
        child: SingleChildScrollView(
          physics: scrollPhysicsForParent,
          child: Column(mainAxisSize: MainAxisSize.min,

            children: [

             /* Container(child:
              Row(children: [
                IconButton(onPressed: (){},
                icon: const Icon(Icons.format_bold )),


                IconButton(onPressed: (){},
                    icon: const Icon(Icons.format_bold ))
              ],)
              ),*/

              SizedBox(height: 100,),
              Container(
                  height:40,
                  width: 600,
                  child: StaticEditorToolbar(composer:_composer ,editor: _docEditor!,anchor: _selectionAnchor,)
              ),

//              Container(height:500,color:Colors.white,
//                child: UneditableSuperEditor.uneditable(
//                  parentScrollable: (v){
//                    setState((){
//                      if(v){
//                        scrollPhysicsForParent=ClampingScrollPhysics();
//                      } else {
//                        scrollPhysicsForParent=NeverScrollableScrollPhysics();
//                      }
//                    });
//                  },
//                  editor: _docEditor!,
//                  composer: _composer,
//                  focusNode: _editorFocusNode,
//                  scrollController: _scrollController,
//                  documentLayoutKey: _docLayoutKey,
//                  maxWidth: 600, // arbitrary choice for maximum width
//                  padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),),
//              ),
        GestureDetector(
          onTap:(){
            print('no doc position ! ');

            DocumentLayout docLayout = _docLayoutKey.currentState as DocumentLayout;
            if(_docEditor!.document.nodes.isNotEmpty) {

              if( _docEditor!.document.nodes.length ==1 &&  _docEditor!.document.nodes.last is ParagraphNode){
                print('is Paranode ');
                ParagraphNode paraNode = _docEditor!.document.nodes.last as ParagraphNode;

                if(paraNode.text.text.isEmpty) {
                  print('paranode is empty ');

                  DocumentComponent lastComponent = docLayout.getComponentByNodeId(
                      _docEditor!.document.nodes.last.id)!;
                  print('${_docEditor!.document.nodes.last}');
                  DocumentPosition position = docLayout.getDocumentPositionNearestToOffset(
                      lastComponent.getOffsetForPosition(_docEditor!.document.nodes.last.endPosition))!;
                  _composer!.selection = DocumentSelection.collapsed(
                    position: position,
                  )/*.collapseDownstream(widget.editContext.editor.document)*/;
                  print('Selectionz');

                  print(_composer!.selection);
                }
              }
            }
          },
          child: Container(
            color:Colors.yellowAccent,
            child: UneditableSuperEditor.uneditable(
//              textStyleBuilder: (v){
//
//                if(v)
//              },


              editor: _docEditor!,
              composer: _composer,
              focusNode: _editorFocusNode,
              scrollController: _scrollController,
              documentLayoutKey: _docLayoutKey,
              maxWidth: 1000, // arbitrary choice for maximum width
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24), parentScrollable: (bool v) {
                if(v ){
                  scrollPhysicsForParent = NeverScrollableScrollPhysics();
                } else scrollPhysicsForParent= ClampingScrollPhysics();

            },
            ),
          ),
        ),


            Text('''
            This is flutter text
                  This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
            This is flutter text
''')
            ],
          ),
        ),
      ),
    );
  }
}
