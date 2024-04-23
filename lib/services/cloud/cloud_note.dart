import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_3/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        text = snapshot.data()[textFieldName] as String;

  @override
  String toString() => 'CloudNote(id: $documentId, userID: $ownerUserId, text: $text)';

  @override
  bool operator ==(covariant CloudNote other) =>
      documentId == other.documentId && ownerUserId == other.ownerUserId && text == other.text;

  @override
  int get hashCode => documentId.hashCode;
}
