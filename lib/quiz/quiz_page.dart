import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/quiz_cubit.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:guidey/quiz/result_page.dart';
import 'package:provider/provider.dart';
import 'package:guidey/quiz/lang_prov.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return BlocProvider(
      create: (_) => QuizCubit(langProvider: langProvider)..startQuiz(),
      child: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<QuizCubit>();

          return Scaffold(
            appBar: AppBar(

              actions: [
                TextButton(
                  onPressed: () {

                    final newLang = langProvider.currentLang == langProvider.enLang
                        ? 'ar'
                        : 'en';
                    cubit.changeLanguage(newLang);
                  },
                  child: Text(
                    langProvider.currentLang == langProvider.enLang ? 'عربي🌍' : 'English🌍',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: state is QuizProgress
                  ? _buildQuizContent(context, cubit)
                  : state is QuizCompleted
                  ? _goToResult(context, state)
                  : const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizCubit cubit) {
    final state = cubit.state as QuizProgress;
    final question = cubit.getCurrentQuestionText();
    final options = cubit.getCurrentOptions();
    final index = state.currentIndex;
    final total = cubit.loadedQuestions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress bar
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "${index + 1} / $total",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: (index + 1) / total,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
        // Question
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Options
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: options.length,
            itemBuilder: (context, i) {
              final option = options[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => cubit.selectAnswers(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    cubit.selectedOption == option ? const Color(0xFF8A6FE8) : Colors.white,
                    foregroundColor:
                    cubit.selectedOption == option ? Colors.white : Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(option),
                ),
              );
            },
          ),
        ),
        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: cubit.currentIndex == 0 ? null : cubit.goBack,
                child: Text(cubit.langProvider.currentLang['previous'] ?? 'Previous'),
              ),
              ElevatedButton(
                onPressed: cubit.selectedOption == null ? null : cubit.nextQuestion,
                child: Text(cubit.langProvider.currentLang['next'] ?? 'Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _goToResult(BuildContext context, QuizCompleted state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            answers: state.selectedAnswers,
            questions: questions,
          ),
        ),
      );
    });
    return const SizedBox();
  }
}