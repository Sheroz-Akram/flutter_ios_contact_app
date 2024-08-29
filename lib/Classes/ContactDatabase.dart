import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactDatabase {
  static final ContactDatabase _instance = ContactDatabase._internal();
  factory ContactDatabase() => _instance;
  ContactDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, phoneNumber TEXT, address TEXT, profilePicture TEXT)',
        );
      },
    );
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contact>> getContacts({String searchQuery = ""}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (searchQuery.isEmpty) {
      // If searchQuery is empty, get all contacts
      maps = await db.query('contacts');
    } else {
      // If searchQuery is not empty, perform a WHERE query to filter by name or phone number
      maps = await db.query(
        'contacts',
        where: 'firstName LIKE ? OR lastName LIKE ? OR phoneNumber LIKE ?',
        whereArgs: [
          '%$searchQuery%', // for firstName match
          '%$searchQuery%', // for lastName match
          '%$searchQuery%' // for phoneNumber match
        ],
      );
    }

    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
