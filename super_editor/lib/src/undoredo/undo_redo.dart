import 'package:super_editor/src/core/document.dart';
import 'package:super_editor/src/core/document_selection.dart';

class UndoRedo {
  static final List<Edit> undoStack = [];
  static final List<Edit> redoStack = [];

  static void addUndoRedo(String whichStack, Edit edit) {
    if (whichStack == 'undo') {
      undoStack.insert(0, edit);
    } else {
      redoStack.insert(0, edit);
    }
  }



  static void mergeStack(String whichStack, Edit edit, int index) {
    if (whichStack == 'undo') {
      undoStack[index] = edit;
      print('undoStack after edit $undoStack');
    } else {
      redoStack[index] =edit;
    }
  }

  static void editStack(String whichStack, Edit edit, int index) {
    if (whichStack == 'undo') {
      undoStack[index] = edit;
      print('undoStack after edit $undoStack');
    } else {
      redoStack[index] =edit;
    }
  }

  static void updateStacks(String fromStack , Edit edit) {

    if (fromStack == 'undo') {
      print('undo');
      if(undoStack.length ==14){
        undoStack.removeLast();
      }

      redoStack.insert(0, edit);
      undoStack.removeAt(0);
      print('after update stacks');
      print('${undoStack}, ${redoStack}');

    } else {
      print('redo');
      undoStack.insert(0, edit);
      redoStack.removeAt(0);

      print('after update stacks');
      print('${undoStack}, ${redoStack}');
    }
  }
}

class Edit {
  DocumentSelection documentSelection;
  String serializedString;
  String action;
  List<DocumentNode> nodes;

  Edit(
      {required this.documentSelection,
      required this.serializedString,
      required this.action,
      required this.nodes});
}
