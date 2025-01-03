import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ReservationDatabase {
  static Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'reservations.db'),
      version: 2, // Augmentez la version de la base de données
      onCreate: (db, version) async {
        // Création initiale de la table
        await db.execute(
          'CREATE TABLE reservations('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT, '
              'datetime TEXT, '
              'type TEXT)', // Inclure "type" dans la création initiale
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Ajouter la colonne "type" si elle n'existe pas encore
          await db.execute('ALTER TABLE reservations ADD COLUMN type TEXT');
        }
      },
    );
  }

  // Ajouter une réservation
  static Future<void> addReservation(String name, String datetime, String type) async {
    final db = await _openDb();
    await db.insert(
      'reservations',
      {'name': name, 'datetime': datetime, 'type': type},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer les réservations par type
  static Future<List<Map<String, dynamic>>> getReservationsByType(String type) async {
    final db = await _openDb();
    return db.query('reservations', where: 'type = ?', whereArgs: [type]);
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
