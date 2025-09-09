import 'package:flutter/material.dart';
import 'package:guidey/quiz/quiz_page.dart';

class AdviesScreen extends StatefulWidget {
  const AdviesScreen({super.key});

  @override
  State<AdviesScreen> createState() => _AdviesScreenState();
}

class _AdviesScreenState extends State<AdviesScreen> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    String text = isEnglish
        ? "No one can truly help you until you decide to help yourself.\n"
        "That’s why it’s important to be honest with yourself when answering the questions\n"
        "only then can we give you the best results and guide you to the path that suits you most."
        : "محدش هيقدر يساعدك فعلاً غير لما تقرر تساعد نفسك.\n"
        "علشان كده خليك صريح مع نفسك وإنت بتجاوب على الأسئلة\n"
        "وساعتها هنقدر نديك أحسن نتيجة ونوجّهك للطريق المناسب ليك";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.deepPurple,
                  size: 50,
                ),
                const SizedBox(height: 16),


                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),


                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                  ),
                  child: Text(
                    isEnglish ? "Start Quiz" : "ابدأ الاختبار",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 12),


                TextButton(
                  onPressed: () {
                    setState(() {
                      isEnglish = !isEnglish;
                    });
                  },
                  child: Text(
                    isEnglish ? "عربي 🌍" : "English 🌍",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

