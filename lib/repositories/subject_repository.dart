import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/analytic_provider.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bukutugas/extensions/firestore_extension.dart';

abstract class BaseSubjectRepository {
  Future<List<Subject>> retrieveItems({
    required String userId,
  });

  Future<String> createSubject({
    required String userId,
    required Subject subject,
  });

  Future<void> updateSubject({
    required String userId,
    required Subject subject,
  });

  Future<void> deleteSubject({
    required String userId,
    required Subject subject,
  });

  Future<void> increaseAssignmentCounter({
    required String userId,
    required String subjectId,
  });
}

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepository(ref.read);
});

class SubjectRepository extends BaseSubjectRepository {
  Reader _read;
  late FirebaseFirestore _firestore;

  SubjectRepository(this._read) {
    _firestore = _read(firestoreProvider);
  }

  @override
  Future<List<Subject>> retrieveItems({required String userId}) async {
    try {
      final snapshot = await _firestore.userSubjectsRef(userId).get();

      return snapshot.docs.map((doc) => Subject.fromDoc(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createSubject(
      {required String userId, required Subject subject}) async {
    try {
      final docRef =
          await _firestore.userSubjectsRef(userId).add(subject.toDoc());

      _read(analyticProvider).logSubjectCreate();

      return docRef.id;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateSubject(
      {required String userId, required Subject subject}) async {
    try {
      await _firestore
          .userSubjectsRef(userId)
          .doc(subject.id)
          .update(subject.toDoc());

      _read(analyticProvider).logSubjectUpdate();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteSubject(
      {required String userId, required Subject subject}) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final subjectAssignmentsSnapshot = await _firestore
            .userSubjectAssignmentsRef(userId, subject.id!)
            .get();

        // delete every assignment before deleting the subject itself
        for (DocumentSnapshot ds in subjectAssignmentsSnapshot.docs) {
          await ds.reference.delete();
        }

        await _firestore.userSubjectsRef(userId).doc(subject.id).delete();
      });

      _read(analyticProvider).logSubjectDelete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> increaseAssignmentCounter(
      {required String userId, required String subjectId}) async {
    try {
      await _firestore
          .userSubjectRef(userId, subjectId)
          .update({'assignment_count': FieldValue.increment(1)});
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
