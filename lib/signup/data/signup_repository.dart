import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/local_database.dart';

class SignupRepository {
  final LocalDatabase localDb = LocalDatabase();
  final supabase = Supabase.instance.client;

  Future<void> registerUser(String email, String password, String role) async {
    final db = await localDb.database;

    final List<Map<String, dynamic>> existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty && existing.first['is_verified'] == 1) {
      throw Exception("Email already verified.");
    }

    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'role': role},
    );

    if (existing.isEmpty) {
      await db.insert('users', {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'role': role,
        'is_verified': 0,
        'is_synced': 0,
      });
    }
  }

  Future<void> markAsVerified(String email) async {
    final db = await localDb.database;
    await db.update(
      'users',
      {'is_verified': 1},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
