import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/analytic_provider.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bukutugas/extensions/firestore_extension.dart';

abstract class BaseAssignmentRepository {
  Future<List<Assignment>> retrieveItems(
      {required String userId, required String subjectId});
  Future<String> createAssignment(
      {required String userId,
      required String subjectId,
      required Assignment assignment});
  Future<void> updateAssignment(
      {required String userId,
      required String subjectId,
      required Assignment assignment});
  Future<void> deleteAssignment(
      {required String userId,
      required String subjectId,
      required Assignment assignment});
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
  Future<List<Assignment>> retrieveItems(
      {required String userId, required String subjectId}) async {
    try {
      final snapshot =
          await _firestore.userAssignmentsRef(userId, subjectId).get();

      return snapshot.docs.map((doc) => Assignment.fromDoc(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createAssignment(
      {required String userId,
      required Assignment assignment,
      required String subjectId}) async {
    try {
      final docRef = await _firestore
          .userAssignmentsRef(userId, subjectId)
          .add(assignment.toDoc());

      _read(analyticProvider).logAssignmentCreate();

      return docRef.id;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateAssignment(
      {required String userId,
      required Assignment assignment,
      required String subjectId}) async {
    try {
      await _firestore
          .userAssignmentsRef(userId, subjectId)
          .doc(assignment.id)
          .update(assignment.toDoc());

      _read(analyticProvider).logAssignmentUpdate();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteAssignment(
      {required String userId,
      required Assignment assignment,
      required String subjectId}) async {
    try {
      await _firestore
          .userAssignmentsRef(userId, subjectId)
          .doc(assignment.id)
          .delete();

      _read(analyticProvider).logAssignmentDelete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
