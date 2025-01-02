import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReservationDatabase {
  static Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'reservations.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE reservations(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, datetime TEXT)',
        );
      },
      version: 1,
    );
  }

  // Ajouter une réservation
  static Future<void> addReservation(String name, String datetime) async {
    final db = await _openDb();
    await db.insert(
      'reservations',
      {'name': name, 'datetime': datetime},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer toutes les réservations
  static Future<List<Map<String, dynamic>>> getReservations() async {
    final db = await _openDb();
    return db.query('reservations');
  }

  // Supprimer une réservation par ID
  static Future<void> deleteReservation(int id) async {
    final db = await _openDb();
    await db.delete(
      'reservations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
