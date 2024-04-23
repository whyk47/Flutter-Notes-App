import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/services/cloud/cloud_note.dart';
import 'package:flutter_application_3/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_application_3/services/cloud/cloud_storage_exceptions.dart';

class FireBaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({
    required String ownerUserId,
  }) =>
      notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .snapshots()
          .map(
            (event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );

  Future<Iterable<CloudNote>> getNotes({
    required String ownerUserId,
  }) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map(
                (doc) => CloudNote.fromSnapshot(doc),
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNote({
    required String ownerUserId,
  }) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final newNote = await document.get();
    return CloudNote(
      documentId: newNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();
  FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;
}
