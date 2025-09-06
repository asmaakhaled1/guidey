import 'package:guidey/quiz/question_model.dart';


abstract class QuizState {}


class QuizInitial extends QuizState {}


class QuizProgress extends QuizState {
  final int currentIndex;
  final Question currentQuestion;

  QuizProgress(this.currentIndex, this.currentQuestion);
}


class QuizCompleted extends QuizState {
  final List<String> selectedAnswers;

  QuizCompleted(this.selectedAnswers);
}


class LanguageChanged extends QuizState {
  final String languageCode;

  LanguageChanged(this.languageCode);
}


class ThemeChanged extends QuizState {
  final bool isDark;

  ThemeChanged(this.isDark);
}