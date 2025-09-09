import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:guidey/quiz/lang_prov.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({required this.langProvider}) : super(QuizInitial());

  final LanguageProvider langProvider;
  String? selectedOption;
  int currentIndex = 0;
  List<String> selectedAnswers = [];

  bool isDark = false;

  List<Question> loadedQuestions = questions;

  void selectAnswers(String answer) {
    selectedOption = answer;
    emit(QuizProgress(currentIndex, loadedQuestions[currentIndex]));
  }

  void nextQuestion() {
    if (selectedOption != null) {
      selectedAnswers.add(selectedOption!);
      selectedOption = null;
      if (currentIndex < loadedQuestions.length - 1) {
        currentIndex++;
        emit(QuizProgress(currentIndex, loadedQuestions[currentIndex]));
      } else {
        emit(QuizCompleted(selectedAnswers));
      }
    }
  }

  void goBack() {
    if (currentIndex > 0) {
      currentIndex--;
      selectedAnswers.removeLast();
      emit(QuizProgress(currentIndex, loadedQuestions[currentIndex]));
    }
  }

  void startQuiz() {
    currentIndex = 0;
    selectedAnswers.clear();
    emit(QuizProgress(currentIndex, loadedQuestions[currentIndex]));
  }


  void changeLanguage(String languageCode) {
    langProvider.setLanguage(languageCode);
    emit(LanguageChanged(languageCode));
    emit(QuizProgress(currentIndex, loadedQuestions[currentIndex]));
  }


  void toggleTheme() {
    isDark = !isDark;
    emit(ThemeChanged(isDark));
  }


  String getCurrentQuestionText() {
    return langProvider.currentLang[loadedQuestions[currentIndex].questionKey]!;
  }

  List<String> getCurrentOptions() {
    return loadedQuestions[currentIndex].optionKeys
        .map((key) => langProvider.currentLang[key]!)
        .toList();
  }
}