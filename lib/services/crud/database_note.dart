// import 'package:flutter/material.dart';
// import 'package:flutter_application_3/services/crud/crud_constants.dart';

// @immutable
// class DatabaseNote {
//   final int id;
//   final int userID;
//   final String text;
//   final bool syncedWithCloud;

//   const DatabaseNote({
//     required this.id,
//     required this.userID,
//     required this.text,
//     required this.syncedWithCloud,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userID = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         syncedWithCloud =
//             (map[syncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, ID = $id, userId = $userID, syncedWithCloud = $syncedWithCloud, text = $text';

//   @override
//   bool operator ==(covariant DatabaseNote other) =>
//       id == other.id &&
//       userID == other.userID &&
//       text == other.text &&
//       syncedWithCloud == other.syncedWithCloud;

//   @override
//   int get hashCode => id.hashCode;
// }
