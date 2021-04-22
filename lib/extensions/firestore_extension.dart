import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension FirestoreExtension on FirebaseFirestore {
  CollectionReference userSubjectsRef(String userId) {
    return this.collection('users').doc(userId).collection('subjects');
  }

  DocumentReference userSubjectRef(String userId, String subjectId) {
    return this.userSubjectsRef(userId).doc(subjectId);
  }

  CollectionReference userSubjectAssignmentsRef(
      String userId, String subjectId) {
    return this
        .userSubjectsRef(userId)
        .doc(subjectId)
        .collection('assignments');
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
