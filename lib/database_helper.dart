import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'Chrysanthemumflower_info.db');

      bool needsUpdate = await _needsDatabaseUpdate(path);
      if (needsUpdate) {
        await _copyDatabaseFromAssets(path);
      }

      return await openDatabase(path);
    } catch (e) {
      print('Error initializing the database: $e');
      rethrow;
    }
  }

  Future<bool> _needsDatabaseUpdate(String path) async {
    bool exists = await File(path).exists();
    return !exists;
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    try {
      if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
        await File(path).delete();
      }

      ByteData data = await rootBundle.load('assets/database/Chrysanthemumflower_info.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    } catch (e) {
      print('Error copying the database: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    try {
      final db = await database;
      return await db.query('Flowers');
    } catch (e) {
      print('Error fetching plants: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getFlowerById(int id) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'Flowers',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      print('Error fetching flower by ID: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getFullFlowerDetailsByName(String name) async {
    final db = await database;

    String cleanedName = name.trim().toLowerCase();

    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT * FROM Flowers
      WHERE LOWER(name) LIKE ?
      LIMIT 1
      ''',
      ['%$cleanedName%'],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> getFlowerIdByImage(String flowerImage) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'Flowers',
        where: 'image = ?',
        whereArgs: [flowerImage],
        limit: 1,
      );
      if (result.isNotEmpty) {
        return result.first['id'] as int;
      }
      return -1;
    } catch (e) {
      print('Error fetching flower ID by image: $e');
      return -1;
    }
  }

  static initialize() async {
    await DatabaseHelper().database;
  }
}
