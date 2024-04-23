// const dbName = 'notes.db';
// const notesTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const syncedWithCloudColumn = 'synced_with_cloud';
// const createUserTable = '''
//   CREATE TABLE IF NOT EXISTS "user" (
//     "id"	INTEGER NOT NULL,
//     "email"	TEXT NOT NULL UNIQUE,
//     PRIMARY KEY("id" AUTOINCREMENT)
//   );
// ''';
// const createNotesTable = '''
//   CREATE TABLE IF NOT EXISTS "note" (
//     "id"	INTEGER NOT NULL,
//     "user_id"	INTEGER NOT NULL,
//     "text"	TEXT,
//     "synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//     FOREIGN KEY("user_id") REFERENCES "user"("id"),
//     PRIMARY KEY("id" AUTOINCREMENT)
//   );
// ''';
