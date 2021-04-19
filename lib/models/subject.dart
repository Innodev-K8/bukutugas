import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  String? id;
  String? name;
  String? teacher;
  List<int>? days;
  String? emoji;
  String? color;

  Subject({
    this.id,
    this.name,
    this.teacher,
    this.days,
    this.emoji,
    this.color,
  });

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    teacher = json['teacher'];
    days = json['days'].cast<int>();
    emoji = json['emoji'];
    color = json['color'];
  }

  Subject.fromDoc(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.get('name');
    teacher = doc.get('teacher');
    days = doc.get('days').cast<int>();
    emoji = doc.get('emoji');
    color = doc.get('color');
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
    return data;
  }
}
