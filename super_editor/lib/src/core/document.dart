import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A read-only document with styled text and multimedia elements.
///
/// A [Document] is comprised of a list of [DocumentNode]s,
/// which describe the type and substance of a piece of content
/// within the document. For example, a [ParagraphNode] holds a
/// single paragraph of text within the document.
///
/// New types of content can be added by subclassing [DocumentNode].
///
/// To represent a specific location within a [Document],
/// see [DocumentPosition].
///
/// A [Document] has no opinion on the visual presentation of its
/// content.
///
/// To edit the content of a document, see [DocumentEditor].
abstract class Document with ChangeNotifier {
  /// Returns all of the content within the document as a list
  /// of [DocumentNode]s.
  List<DocumentNode> get nodes;

  /// Returns the [DocumentNode] with the given [nodeId], or [null]
  /// if no such node exists.
  DocumentNode? getNodeById(String nodeId);

  /// Returns the [DocumentNode] at the given [index], or [null]
  /// if no such node exists.
  DocumentNode? getNodeAt(int index);

  /// Returns the index of the given [node], or [-1] if the [node]
  /// does not exist within this [Document].
  int getNodeIndex(DocumentNode node);

  /// Returns the [DocumentNode] that appears immediately before the
  /// given [node] in this [Document], or null if the given [node]
  /// is the first node, or the given [node] does not exist in this
  /// [Document].
  DocumentNode? getNodeBefore(DocumentNode node);

  /// Returns the [DocumentNode] that appears immediately after the
  /// given [node] in this [Document], or null if the given [node]
  /// is the last node, or the given [node] does not exist in this
  /// [Document].
  DocumentNode? getNodeAfter(DocumentNode node);

  /// Returns the [DocumentNode] at the given [positigetDocumentSelectionInRegionon], or [null] if
  /// no such node exists in this [Document].
  DocumentNode? getNode(DocumentPosition position);

  /// Returns a [DocumentRange] that ranges from [position1] to
  /// [position2], including [position1] and [position2].
  // TODO: this method is misleading (#48) because if `position1` and
  //       `position2` are in the same node, they may be returned
  //       in the wrong order because the document doesn't know
  //       how to interpret positions within a node.
  DocumentRange getRangeBetween(DocumentPosition position1, DocumentPosition position2);

  /// Returns all [DocumentNode]s from [position1] to [position2], including
  /// the nodes at [position1] and [position2].
  List<DocumentNode> getNodesInside(DocumentPosition position1, DocumentPosition position2);

  /// Returns [true] if the content in the [other] document is equivalent to
  /// the content in this document, ignoring any details that are unrelated
  /// to content, such as individual node IDs.
  ///
  /// To compare [Document] equality, use the standard [==] operator.
  bool hasEquivalentContent(Document other);
}

/// A span within a [Document] that begins at [start] and
/// ends at [end].
///
/// The [start] position must come before the [end] position in
/// the document.
class DocumentRange {
  DocumentRange({
    required this.start,
    required this.end,
  });

  final DocumentPosition start;
  final DocumentPosition end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentRange && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() {
    return '[DocumentRange] - from: ($start), to: ($end)';
  }
}

/// A logical position within a [Document].
///
/// A [DocumentPosition] points to a specific node by way of a [nodeId],
/// and points to a specific position within the node by way of a
/// [nodePosition].
///
/// The type of the [nodePosition] depends upon the type of [DocumentNode]
/// that this position points to. For example, a [ParagraphNode]
/// uses a [TextPosition] to represent a [nodePosition].
class DocumentPosition {
  const DocumentPosition({
    required this.nodeId,
    required this.nodePosition,
  });

  /// ID of a [DocumentNode] within a [Document].
  final String nodeId;

  /// Node-specific representation of a position.
  ///
  /// For example: a paragraph node might use a [TextNodePosition].
  final NodePosition nodePosition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentPosition && nodeId == other.nodeId && nodePosition == other.nodePosition;


  @override
  int get hashCode => nodeId.hashCode ^ nodePosition.hashCode;

  DocumentPosition copyWith({
    String? nodeId,
    NodePosition? nodePosition,
  }) {
    return DocumentPosition(
      nodeId: nodeId ?? this.nodeId,
      nodePosition: nodePosition ?? this.nodePosition,
    );
  }

  @override
  String toString() {
    return '[DocumentPosition] - node: "$nodeId", position: ($nodePosition)';
  }
}

/// A single content node within a [Document].
abstract class DocumentNode implements ChangeNotifier {
  /// ID that is unique within a [Document].
  String get id;

  /// Returns the [NodePosition] that corresponds to the beginning
  /// of content in this node.
  ///
  /// For example, a [ParagraphNode] would return [TextNodePosition(offset: 0)].
  NodePosition get beginningPosition;

  /// Returns the [NodePosition] that corresponds to the end of the
  /// content in this node.
  ///
  /// For example, a [ParagraphNode] would return
  /// [TextNodePosition(offset: text.length)].
  NodePosition get endPosition;

  /// Inspects [position1] and [position2] and returns the one that's
  /// positioned further upstream in this [DocumentNode].
  ///
  /// For example, in a [TextNode], this returns the [TextPosition]
  /// for the character that appears earlier in the block of text.
  NodePosition selectUpstreamPosition(
    NodePosition position1,
    NodePosition position2,
  );

  /// Inspects [position1] and [position2] and returns the one that's
  /// positioned further downstream in this [DocumentNode].
  ///
  /// For example, in a [TextNode], this returns the [TextPosition]
  /// for the character that appears later in the block of text.
  NodePosition selectDownstreamPosition(
    NodePosition position1,
    NodePosition position2,
  );

  /// Returns a node-specific representation of a selection from
  /// [base] to [extent].
  ///
  /// For example, a [ParagraphNode] would return a [TextNodeSelection].
  NodeSelection computeSelection({
    required NodePosition base,
    required NodePosition extent,
  });

  /// Returns a plain-text version of the content in this node
  /// within [selection], or null if the given selection does
  /// not make sense as plain-text.
  String? copyContent(NodeSelection selection);

  /// Returns true of the [other] node is the same type as this
  /// node, and contains the same content.
  ///
  /// Content equivalency ignores the node ID.
  bool hasEquivalentContent(DocumentNode other);
}

/// Marker interface for a selection within a [DocumentNode].
abstract class NodeSelection {
  // marker interface
}

/// Marker interface for all node positions.
///
/// A node position is a logical position within a [DocumentNode],
/// e.g., a [TextNodePosition] within a [ParagraphNode], or a [BinaryNodePosition]
/// within an [ImageNode].
abstract class NodePosition {
  // marker interface
}
