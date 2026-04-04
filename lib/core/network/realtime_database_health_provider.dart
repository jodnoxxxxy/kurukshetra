import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RealtimeDatabaseState {
  connected,
  connectedButRestricted,
  disconnected,
  error,
}

class RealtimeDatabaseHealth {
  final RealtimeDatabaseState state;
  final String message;
  final DateTime checkedAt;

  const RealtimeDatabaseHealth({
    required this.state,
    required this.message,
    required this.checkedAt,
  });
}

const String _databaseUrl =
    'https://kurukshetra-9d993-default-rtdb.firebaseio.com/';

final realtimeDatabaseHealthProvider =
    StreamProvider<RealtimeDatabaseHealth>((ref) {
  final db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: _databaseUrl,
  );

  return db.ref('.info/connected').onValue.asyncMap((event) async {
    final isConnected = event.snapshot.value == true;
    if (!isConnected) {
      return RealtimeDatabaseHealth(
        state: RealtimeDatabaseState.disconnected,
        message: 'Realtime Database not connected.',
        checkedAt: DateTime.now(),
      );
    }

    try {
      await db.ref().limitToFirst(1).get();
      return RealtimeDatabaseHealth(
        state: RealtimeDatabaseState.connected,
        message: 'Realtime Database connected and readable.',
        checkedAt: DateTime.now(),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return RealtimeDatabaseHealth(
          state: RealtimeDatabaseState.connectedButRestricted,
          message:
              'Connected to Realtime Database, but reads are restricted by rules.',
          checkedAt: DateTime.now(),
        );
      }
      return RealtimeDatabaseHealth(
        state: RealtimeDatabaseState.error,
        message: 'Realtime Database error: ${e.message ?? e.code}',
        checkedAt: DateTime.now(),
      );
    } catch (e) {
      return RealtimeDatabaseHealth(
        state: RealtimeDatabaseState.error,
        message: 'Realtime Database check failed: $e',
        checkedAt: DateTime.now(),
      );
    }
  });
});
