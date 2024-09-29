
//import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
//import 'package:flutter/rendering.dart';

class Question extends Equatable{
  //each question have an id and title
   final String questionTitle;

   final String imageUrl;
   final String category;
  //each question have choices
   final List<String> options;
   final String answer;
  //check whether the question is a tree question or not
   final bool isTree;

  const Question({ 
    required this.questionTitle,
    required this.imageUrl,
    required this.category,
    required this.answer,
    required this.options,
    required this.isTree,
  });

  @override 
  List<Object> get props=> [ 
    questionTitle,
    imageUrl,
    category,
    options,
    answer,
    isTree,
  ];

  factory Question.fromMap(Map<String, dynamic> map) {
    //if(map == null) return null;
    return Question( 
      questionTitle: map['questionTitle'] ?? '',
      answer: map['answer'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      options: List<String>.from(map['options']??[]),
      isTree: map['isTree'] ?? false,
    );
  }
}