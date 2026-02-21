import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_database.dart';

class SyncService {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  Future<void> syncOnStart() async {
    final db = await _localDb.database;

    final List<Map<String, dynamic>> unsyncedUsers = await db.query(
      'users',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    if (unsyncedUsers.isEmpty) return;

    for (var user in unsyncedUsers) {
      try {
        await _supabase.from('profiles').upsert({
          'id': user['id'],
          'email': user['email'],
          'role': user['role'],
        });

        await db.update(
          'users',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [user['id']],
        );
      } catch (e) {
        continue;
      }
    }
  }
}
