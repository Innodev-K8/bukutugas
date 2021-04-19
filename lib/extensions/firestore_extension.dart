import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreExtension on FirebaseFirestore {
  CollectionReference userSubjectsRef(String userId) {
    return this.collection('users').doc(userId).collection('subjects');
  }
}
