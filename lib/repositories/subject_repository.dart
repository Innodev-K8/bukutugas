import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bukutugas/extensions/firestore_extension.dart';

abstract class BaseSubjectRepository {
  Future<List<Subject>> retrieveItems({required String userId});
  Future<String> createSubject(
      {required String userId, required Subject subject});
  Future<void> updateSubject(
      {required String userId, required Subject subject});
  Future<void> deleteSubject(
      {required String userId, required Subject subject});
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
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteSubject(
      {required String userId, required Subject subject}) async {
    try {
      await _firestore.userSubjectsRef(userId).doc(subject.id).delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
