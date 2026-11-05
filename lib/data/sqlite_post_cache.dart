
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/post.dart';
import 'post_cache.dart';

/// Part 5: the real cache on the phone, in an SQLite table.
///
///   posts(id INTEGER PRIMARY KEY, user_id INTEGER, title TEXT, body TEXT)
///
/// The tests use MemoryPostCache; this class is checked on the emulator
/// (load once online, then turn on airplane mode and restart the app).
class SqlitePostCache implements PostCache {
  Database? _db;

  /// Given: opens (and on first use creates) the database.
  Future<Database> _open() async {
    return _db ??= await openDatabase(
      join(await getDatabasesPath(), 'campus_feed.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE posts(id INTEGER PRIMARY KEY, user_id INTEGER, title TEXT, body TEXT)',
      ),
    );
  }

  @override
  Future<void> save(List<Post> posts) async {
    // TODO(5.1): in one transaction: delete all rows, then insert every post
    // (columns id, user_id, title, body).
    final db = await _open();
    await db.transaction((txn) async {
      await txn.delete('posts');
      for (final post in posts) {
        await txn.insert('posts', {
          'id': post.id,
          'user_id': post.userId,
          'title': post.title,
          'body': post.body,
        });
      }
    });
  }

  @override
  Future<List<Post>> load() async {
    // TODO(5.2): query all rows ordered by id and turn each row back into a Post.
    final db = await _open();
    final rows = await db.query('posts', orderBy: 'id ASC');
    return rows.map((row) => Post(
      id: row['id'] as int,
      userId: row['user_id'] as int,
      title: row['title'] as String,
      body: row['body'] as String,
    )).toList();
  }
}
