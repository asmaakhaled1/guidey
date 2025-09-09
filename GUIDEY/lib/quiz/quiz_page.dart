import 'package:flutter/material.dart';
import 'package:guidey/quiz/quiz_cubit.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/quiz_state.dart';
import 'package:guidey/quiz/result_page.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit()..startQuiz(),
      child: Scaffold(
        appBar: AppBar(
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
          child: BlocConsumer<QuizCubit, QuizState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is QuizProgress) {
                final question = state.question;
                final index = state.index;
                final total = questions.length;
                final cubit = context.read<QuizCubit>();

                return InteractiveViewer(
                  panEnabled: true, // للسحب
                    // أقل تكبير
                  maxScale: 3,      // أقصى تكبير
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress bar and question number
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Question ${index + 1} of $total",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: (index + 1) / total,
                              backgroundColor: Colors.grey[300],
                              valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ],
                        ),
                      ),

                      // Question text
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Options
                      Expanded(
                        child: ListView.builder(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: question.options.length,
                          itemBuilder: (context, i) {
                            final option = question.options[i];
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                onPressed: () =>
                                    cubit.selectAnswers(option),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  cubit.selectedOption == option
                                      ? const Color(0xFF8A6FE8)
                                      : Colors.white,
                                  foregroundColor:
                                  cubit.selectedOption == option
                                      ? Colors.white
                                      : Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side:
                                    const BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text(option),
                              ),
                            );
                          },
                        ),
                      ),

                      // Previous and Next buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed:
                              index == 0 ? null : cubit.goBack,
                              child: const Text(
                                "Previous",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: cubit.selectedOption == null
                                  ? null
                                  : cubit.nextQuestion,
                              child: const Text(
                                "Next",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is QuizCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        answers: state.answers,
                        questions: questions,
                      ),
                    ),
                  );
                });
                return const SizedBox();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}