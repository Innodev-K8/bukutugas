import 'package:cloud_firestore/cloud_firestore.dart';

enum AssignmentStatus {
  todo,
  done,
}

class Assignment {
  String? id;
  String? userId;
  String? subjectId;
  String? title;
  String? description;
  String? deadline;
  AssignmentStatus? status;
  List<String>? attachments;

  Assignment({
    this.id,
    this.userId,
    this.subjectId,
    this.title,
    this.description,
    this.deadline,
    this.status = AssignmentStatus.todo,
    this.attachments,
  });

  Assignment.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    userId = json?['user_id'];
    subjectId = json?['subject_id'];
    title = json?['title'];
    description = json?['description'];
    deadline = json?['deadline'];
    attachments = json?['attachments']?.cast<String>();

    switch (json?['status']) {
      case 'done':
        status = AssignmentStatus.done;
        break;
      case 'todo':
      default:
        status = AssignmentStatus.todo;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['subject_id'] = this.subjectId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['attachments'] = this.attachments;

    switch (this.status) {
      case AssignmentStatus.done:
        data['status'] = 'done';
        break;
      case AssignmentStatus.todo:
      default:
        data['status'] = 'todo';
        break;
    }

    return data;
  }
}
