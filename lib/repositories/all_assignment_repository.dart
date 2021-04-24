import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseAssignmentRepository {
  Future<List<Assignment>> retrieveItems({required String userId});

  Future<Assignment?> findAssignmentById({
    required String userId,
    required String assignmentId,
  });
}

final assignmentRepositoryProvider = Provider<AssignmentRepository>((ref) {
  return AssignmentRepository(ref.read);
});

class AssignmentRepository extends BaseAssignmentRepository {
  Reader _read;
  late FirebaseFirestore _firestore;

  AssignmentRepository(this._read) {
    _firestore = _read(firestoreProvider);
  }

  @override
  Future<List<Assignment>> retrieveItems({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collectionGroup('assignments')
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .where(
            'status',
            isEqualTo: 'todo',
          )
          .get();

      return snapshot.docs.map((doc) => Assignment.fromDoc(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<Assignment?> findAssignmentById(
      {required String userId, required String assignmentId}) async {
    try {
      _read(firebaseCrashlyticsProvider).log('Trying to find assignment by id');

      _read(firebaseCrashlyticsProvider).setCustomKey('userId', userId);
      _read(firebaseCrashlyticsProvider)
          .setCustomKey('assignmentId', assignmentId);

      final snapshot = await _firestore
          .collectionGroup('assignments')
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .where(
            'status',
            isEqualTo: 'todo',
          )
          .get();

      final QueryDocumentSnapshot? result = snapshot.docs
          .firstWhere((doc) => doc.id == assignmentId, orElse: null);

      if (result == null) return null;

      return Assignment.fromDoc(result);
    } on FirebaseException catch (error, st) {
      _read(firebaseCrashlyticsProvider).recordError(error, st);

      throw CustomException(message: error.message);
    }
  }
}
