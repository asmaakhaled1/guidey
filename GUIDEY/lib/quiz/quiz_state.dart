import 'package:flutter/material.dart';
import 'package:guidey/quiz/question_model.dart';


class LanguageChanged extends QuizState {
  final String languageCode;
  LanguageChanged(this.languageCode);
}

class QuizState {}

class QuizInitial extends QuizState{}

class QuizProgress extends QuizState{

  final int index;

  final Question question;

  QuizProgress(this.index,this.question);

}

class QuizCompleted extends QuizState{

  final List <String> answers;
  QuizCompleted(this.answers);
}


class ThemeChanged extends QuizState {
  final bool isDark;
  ThemeChanged(this.isDark);
}