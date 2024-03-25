import 'dart:async';
import '../model/post_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase('blog.db', version: 1, onCreate: (
      sql.Database database,
      int version,
    ) async {
      await createTables(database);
    });
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE post(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      content TEXT,
      imagePath TEXT,
      isSelected INTEGER,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<int> insertPost(PostModel post) async {
    final db = await DatabaseHelper.db();
    return await db.insert('post', post.toMap());
  }

  static Future<List<PostModel>> getPosts() async {
    final db = await DatabaseHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('post');
    return List.generate(maps.length, (i) {
      return PostModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        imagePath: maps[i]['imagePath'],
        isSelected: maps[i]['isSelected'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  static Future<List<PostModel>> findPosts(String title) async {
    final db = await DatabaseHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('post', where: 'title = ?', whereArgs: [title]);
    return List.generate(maps.length, (i) {
      return PostModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        imagePath: maps[i]['imagePath'],
        isSelected: maps[i]['isSelected'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  static Future<int> updatePost(PostModel post) async {
    final db = await DatabaseHelper.db();
    return await db.update(
      'post',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  static Future<int> deletePost(int postId) async {
    final db = await DatabaseHelper.db();
    return await db.delete('post', where: 'id = ?', whereArgs: [postId]);
  }
}
