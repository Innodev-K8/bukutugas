import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String? id;
  String? title;
  String? description;
  String? deadline;
  String? status;
  List<String>? attachments;

  Assignment({
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.status = 'todo',
    this.attachments,
  });

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    deadline = json['deadline'];
    status = json['status'];
    attachments = json['attachments'].cast<String>();
  }

  Assignment.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() ?? {};

    id = doc.id;

    title = json['title'];
    description = json['description'];
    deadline = json['deadline'];
    status = json['status'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toDoc() {
    return toJson()..remove('id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['status'] = this.status;
    data['attachments'] = this.attachments;
    return data;
  }
}
