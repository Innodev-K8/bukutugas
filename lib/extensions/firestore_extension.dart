import 'package:cloud_firestore/cloud_firestore.dart';

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
