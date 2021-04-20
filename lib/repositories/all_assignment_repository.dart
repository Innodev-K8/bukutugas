import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/analytic_provider.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bukutugas/extensions/firestore_extension.dart';

abstract class BaseAssignmentRepository {
  Future<List<Assignment>> retrieveItems({required String userId});
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
      // final snapshot =
      //     await _firestore.collectionGroup();

      // return snapshot.docs.map((doc) => Assignment.fromDoc(doc)).toList();
      //
      return [];
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
