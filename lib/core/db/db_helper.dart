import 'dart:async';
import 'package:blog_app/core/entities/login.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import '../model/post_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../model/user_model.dart';

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

    await database.execute("""CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      email TEXT  NOT NULL,
      name TEXT NOT NULL,
      phone INTEGER,
      password TEXT NOT NULL,
      role TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
 
    )""");
  }

  static Future<int> insertPost(PostModel post) async {
    try {
      final db = await DatabaseHelper.db();
      return await db.insert('post', post.toMap());
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> createUser(UserModel userModel) async {
    try {
      final db = await DatabaseHelper.db();
      return await db.insert('user', userModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<PostModel>> getPosts() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<PostModel>> findPosts(String value) async {
    String searchString1 = '$value%';
    String searchString2 = '$value%';

    try {
      final db = await DatabaseHelper.db();
      final List<Map<String, dynamic>> maps = await db.query(
        'post',
        where: 'title LIKE  ? OR content LIKE ?',
        whereArgs: [searchString1, searchString2],
      );
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
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> updatePost(PostModel post) async {
    try {
      final db = await DatabaseHelper.db();
      return await db.update(
        'post',
        post.toMap(),
        where: 'id = ?',
        whereArgs: [post.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> deletePost(int postId) async {
    try {
      final db = await DatabaseHelper.db();
      return await db.delete('post', where: 'id = ?', whereArgs: [postId]);
    } catch (e) {
      rethrow;
    }
  }

  //register
  static Future<int> register(UserModel userModel) async {
    try {
      final db = await DatabaseHelper.db();
      return await db.insert('user', userModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  //login
  static Future<List<UserModel>> login(LoginModel loginModel) async {
    String email = loginModel.email;
    String password = loginModel.password;
    final db = await DatabaseHelper.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return UserModel(
          id: maps[i]['id'],
          email: maps[i]['email'],
          name: maps[i]['name'],
          phone: maps[i]['phone'],
          password: maps[i]['password'],
          role: maps[i]['role'],
          createdAt: DateTime.parse(maps[i]['createdAt']),
        );
      });
    } else {
      throw LoginException();
    }
  }
}
