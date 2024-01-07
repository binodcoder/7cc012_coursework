import 'dart:async';
import 'package:my_blog_bloc/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'blog.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE posts (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            imageUrl TEXT
          )
        ''');
    });
  }

  Future<int> insertPost(Post post) async {
    final db = await database;
    return await db!.insert('posts', post.toMap());
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('posts');
    return List.generate(maps.length, (i) {
      return Post(
        maps[i]['id'],
        maps[i]['title'],
        maps[i]['content'],
        maps[i]['imageUrl'],
      );
    });
  }

  Future<int> updatePost(Post post) async {
    final db = await database;
    return await db!.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  Future<int> deletePost(String postId) async {
    final db = await database;
    return await db!.delete('posts', where: 'id = ?', whereArgs: [postId]);
  }
}
