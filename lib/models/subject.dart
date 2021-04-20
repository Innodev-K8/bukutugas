import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  String? id;
  String? name;
  String? teacher;
  List<int>? days;
  String? emoji;
  String? color;
  int? assignmentCount;

  Subject({
    this.id,
    this.name,
    this.teacher,
    this.days,
    this.emoji,
    this.color,
    this.assignmentCount = 0,
  });

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    teacher = json['teacher'];
    days = json['days'].cast<int>();
    emoji = json['emoji'];
    color = json['color'];
    assignmentCount = json['assignment_count'];
  }

  Subject.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() ?? {};

    id = doc.id;

    name = json['name'];
    teacher = json['teacher'];
    days = json['days'].cast<int>();
    emoji = json['emoji'];
    color = json['color'];
    assignmentCount = json['assignment_count'];
  }

  Map<String, dynamic> toDoc() {
    return toJson()..remove('id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['teacher'] = this.teacher;
    data['days'] = this.days;
    data['emoji'] = this.emoji;
    data['color'] = this.color;
    data['assignment_count'] = this.assignmentCount;
    return data;
  }
}
