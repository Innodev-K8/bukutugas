import 'dart:io';

import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/analytic_provider.dart';
import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bukutugas/extensions/firestore_extension.dart';
import 'package:path/path.dart';

abstract class BaseSubjectAssignmentRepository {
  Future<List<Assignment>> retrieveItems({
    required String userId,
    required String subjectId,
  });

  Future<String> createAssignment({
    required String userId,
    required String subjectId,
    required Assignment assignment,
  });

  Future<void> updateAssignment({
    required String userId,
    required String subjectId,
    required Assignment assignment,
  });

  Future<void> markAssignmentStatusAs({
    required String userId,
    required String subjectId,
    required Assignment assignment,
    required AssignmentStatus status,
  });

  Future<void> deleteAssignment({
    required String userId,
    required String subjectId,
    required Assignment assignment,
  });
}

final subjectAssignmentRepositoryProvider =
    Provider<SubjectAssignmentRepository>((ref) {
  return SubjectAssignmentRepository(ref.read);
});

class SubjectAssignmentRepository extends BaseSubjectAssignmentRepository {
  Reader _read;
  late FirebaseFirestore _firestore;

  SubjectAssignmentRepository(this._read) {
    _firestore = _read(firestoreProvider);
  }

  @override
  Future<List<Assignment>> retrieveItems(
      {required String userId, required String subjectId}) async {
    try {
      final snapshot =
          await _firestore.userSubjectAssignmentsRef(userId, subjectId).get();

      return snapshot.docs.map((doc) => Assignment.fromDoc(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createAssignment({
    required String userId,
    required Assignment assignment,
    required String subjectId,
    List<File> attachmentFiles = const [],
  }) async {
    try {
      DocumentReference? docRef;

      await _firestore.runTransaction((transaction) async {
        // create the assignments
        docRef = await _firestore
            .userSubjectAssignmentsRef(userId, subjectId)
            .add({});

        if (docRef?.id == null) return;

        final subjectRef = _firestore.userSubjectRef(userId, subjectId);

        // set the assignment owner to later fetch using collection group
        assignment.userId = userId;
        assignment.attachments = [];

        for (final File attachmentFile in attachmentFiles) {
          final uploadTask = await _read(firebaseStorageProvider)
              .userSubjectAssignmentRef(userId, subjectId, docRef!.id)
              .child(basename(attachmentFile.path))
              .putFile(attachmentFile);

          assignment.attachments?.add(await uploadTask.ref.getDownloadURL());
        }

        transaction.set(docRef!, assignment.toDoc());

        transaction.update(subjectRef, {
          'assignment_count': FieldValue.increment(1),
        });
      });

      if (docRef == null) {
        throw CustomException(message: 'Gagal membuat tugas');
      }

      _read(analyticProvider).logAssignmentCreate();

      return docRef!.id;
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
          .userSubjectAssignmentsRef(userId, subjectId)
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
      await _firestore.runTransaction((transaction) async {
        final assignmentRef = _firestore
            .userSubjectAssignmentsRef(userId, subjectId)
            .doc(assignment.id);
        final subjectRef = _firestore.userSubjectRef(userId, subjectId);

        int counterAction = -1;

        // some status that already counted
        if (assignment.status == AssignmentStatus.done) {
          counterAction = 0;
        }

        final listResult = await _read(firebaseStorageProvider)
            .userSubjectAssignmentRef(userId, subjectId, assignment.id!)
            .list();

        for (final fileRef in listResult.items) {
          await fileRef.delete();
        }

        transaction.delete(assignmentRef);
        transaction.update(subjectRef, {
          'assignment_count': FieldValue.increment(counterAction),
        });
      });

      _read(analyticProvider).logAssignmentDelete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> markAssignmentStatusAs({
    required String userId,
    required String subjectId,
    required Assignment assignment,
    required AssignmentStatus status,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final assignmentRef = _firestore
            .userSubjectAssignmentsRef(userId, subjectId)
            .doc(assignment.id);

        final subjectRef = _firestore.userSubjectRef(userId, subjectId);

        String statusString = 'todo';
        int counterAction = 0;

        switch (status) {
          case AssignmentStatus.done:
            statusString = 'done';

            if (assignment.status == AssignmentStatus.done) {
              counterAction = 0;
            } else {
              counterAction = -1;
            }
            break;
          case AssignmentStatus.todo:
            statusString = 'todo';

            if (assignment.status == AssignmentStatus.todo) {
              counterAction = 0;
            } else {
              counterAction = 1;
            }
            break;
        }

        transaction.update(assignmentRef, {
          'status': statusString,
        });

        transaction.update(subjectRef, {
          'assignment_count': FieldValue.increment(counterAction),
        });
      });

      _read(analyticProvider).logAssignmentUpdate();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
