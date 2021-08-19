import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/models/subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension FirestoreExtension on FirebaseFirestore {
  CollectionReference<Subject> userSubjectsRef(String userId) {
    return this
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .withConverter<Subject>(
          fromFirestore: (snapshot, _) =>
              Subject.fromJson(snapshot.data())..id = snapshot.id,
          toFirestore: (subject, _) => subject.toJson()..remove('id'),
        );
  }

  DocumentReference<Subject> userSubjectRef(String userId, String subjectId) {
    return this.userSubjectsRef(userId).doc(subjectId);
  }

  CollectionReference<Assignment> userSubjectAssignmentsRef(
      String userId, String subjectId) {
    return this
        .userSubjectsRef(userId)
        .doc(subjectId)
        .collection('assignments')
        .withConverter<Assignment>(
          fromFirestore: (snapshot, _) =>
              Assignment.fromJson(snapshot.data())..id = snapshot.id,
          toFirestore: (asignment, _) => asignment.toJson()..remove('id'),
        );
  }

  Query<Assignment> userAssignmentsRef(String userId) {
    return this
        .collectionGroup('assignments')
        .withConverter<Assignment>(
          fromFirestore: (snapshot, _) =>
              Assignment.fromJson(snapshot.data())..id = snapshot.id,
          toFirestore: (asignment, _) => asignment.toJson()..remove('id'),
        )
        .where(
          'user_id',
          isEqualTo: userId,
        )
        .where(
          'status',
          isEqualTo: 'todo',
        );
  }
}

extension FirebaseStorageExtension on FirebaseStorage {
  Reference userSubjectRef(String userId, String subjectId) {
    return this.ref().child(userId).child(subjectId);
  }

  Reference userSubjectAssignmentRef(
      String userId, String subjectId, String assignmentId) {
    return this.userSubjectRef(userId, subjectId).child(assignmentId);
  }
}
