// import 'dart:async';

// import 'package:flutter_application_3/extensions/list/filter.dart';
// import 'package:flutter_application_3/services/crud/database_note.dart';
// import 'package:flutter_application_3/services/crud/database_user.dart';
// import 'package:flutter_application_3/services/crud/crud_constants.dart';
// import 'package:flutter_application_3/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart'
//     show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;

// class NotesService {
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController =
//         StreamController<List<DatabaseNote>>.broadcast(onListen: () {
//       _notesStreamController.sink.add(_notes);
//     });
//   }
//   factory NotesService() => _shared;

//   DatabaseUser? _user;
//   List<DatabaseNote> _notes = [];
//   Database? _db;
//   Database? get db => _db;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note) {
//     final currentUser = _user;
//     if (currentUser != null) {
//       return note.userID == currentUser.id;
//     } else {
//       throw UserShouldBeSetBeforeReadingAllNotes();
//     }
//   });

//   Database _getDbOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       return;
//     }
//   }

//   Future<void> open() async {
//     if (db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       await db.execute(createUserTable);
//       await db.execute(createNotesTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }

//   Future<void> close() async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     await db.close();
//     _db = null;
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//     final userID =
//         await db.insert(userTable, {emailColumn: email.toLowerCase()});
//     if (userID != 0) {
//       return DatabaseUser(id: userID, email: email);
//     }
//     throw CouldNotCreateUser();
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       return DatabaseUser.fromRow(results.first);
//     } else {
//       throw CouldNotFindUser();
//     }
//   }

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final user = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     final noteID = await db.insert(notesTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       syncedWithCloudColumn: 1,
//     });
//     if (noteID != 0) {
//       final note = DatabaseNote(
//         id: noteID,
//         userID: owner.id,
//         text: text,
//         syncedWithCloud: true,
//       );
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//     throw CouldNotCreateNote();
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final deletedCount = await db.delete(
//       notesTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final deletedCount = await db.delete(notesTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return deletedCount;
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final notes = await db.query(
//       notesTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (notes.isNotEmpty) {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notes.add(note);
//       return note;
//     }
//     throw CouldNotFindNote();
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     final notes = await db.query(
//       notesTable,
//     );
//     return notes.map((row) => DatabaseNote.fromRow(row));
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDbOrThrow();
//     await getNote(id: note.id);
//     final updatesCount = await db.update(
//       notesTable,
//       {
//         textColumn: text,
//         syncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     }
//     final updatedNote = await getNote(id: note.id);
//     _notes.removeWhere((note) => note.id == updatedNote.id);
//     _notes.add(updatedNote);
//     _notesStreamController.add(_notes);
//     return updatedNote;
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }
// }
