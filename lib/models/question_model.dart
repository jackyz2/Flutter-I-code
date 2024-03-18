import 'package:flutter/rendering.dart';

class Question{
  //each question have an id and title
  final String id;
  final String title;
  //each question have choices
  final Map<String, bool> options;
  
  //Question constructor
  Question({
    required this.id,
    required this.title,
    required this.options,
  });

  @override
  String toString() {
    return 'Question(id: $id, title: $title, options: $options)';
  }
}