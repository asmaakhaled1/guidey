import 'package:flutter/material.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:guidey/quiz/quiz_page.dart';
import 'package:guidey/services/gemini_services.dart';
import '../roadmap_screen.dart';

class ResultScreen extends StatelessWidget {
  final List<Question> questions;
  final List<String> answers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  String cleanMarkdown(String text) {
    return text
        .replaceAll(RegExp(r''), '')
        .replaceAll(RegExp(r'[_`~]'), '')
        .trim();
  }

  List<Widget> buildContentWidgets(String content) {
    List<Widget> widgets = [];
    List<String> lines =
    content.split('\n').where((l) => l.trim().isNotEmpty).toList();

    for (var line in lines) {
      String cleanLine = cleanMarkdown(line);

      if (cleanLine.startsWith('- ')) {
        widgets.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(cleanLine.substring(2),
                  style: const TextStyle(fontSize: 16, height: 1.4)),
            ),
          ],
        ));
      } else if (RegExp(r'^\d+.').hasMatch(cleanLine)) {
        widgets.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${cleanLine.split('.').first}. ',
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                cleanLine.substring(cleanLine.indexOf('.') + 1).trim(),
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ],
        ));
      } else {
        widgets.add(Text(cleanLine,
            style: const TextStyle(fontSize: 16, height: 1.4)));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> sectionStyles = {
      'Recommended Career': {
        'icon': Icons.work,
        'color': Colors.blue.shade100,
        'iconColor': Colors.blue
      },
      'Why This Career Fits You': {
        'icon': Icons.favorite,
        'color': Colors.purple[100],
        'iconColor': Colors.purple[700]
      },
      'Required Skills': {
        'icon': Icons.build,
        'color': Colors.orange.shade100,
        'iconColor': Colors.orange
      },
      'Steps to Get Started': {
        'icon': Icons.rocket_launch,
        'color': Colors.green.shade100,
        'iconColor': Colors.green
      },
      'Additional Advice': {
        'icon': Icons.lightbulb,
        'color': Colors.yellow.shade100,
        'iconColor': Colors.yellow[800]
      },
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 85,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
            ),
          ),
        ),
        title: const Text(
          'Your Career Result',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: FutureBuilder<String>(
        future: GeminiService().getCareerResult(questions, answers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String data = snapshot.data ?? 'No result found';
            List<String> sections =
            data.split('##').where((s) => s.trim().isNotEmpty).toList();

            // استخراج اسم الكارير من قسم "Recommended Career"
            String recommendedCareerName = '';
            for (var section in sections) {
              if (section.trim().startsWith('Recommended Career')) {
                List<String> lines = section.trim().split('\n');
                if (lines.length > 1) {
                  recommendedCareerName = cleanMarkdown(lines[1].trim());
                }
              }
            }

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InteractiveViewer(
                      panEnabled: true,
                      maxScale: 3,
                      child: ListView.builder(
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          List<String> lines =
                          sections[index].trim().split('\n');
                          String title = lines.first.trim();
                          String content =
                          lines.skip(1).join('\n').trim();

                          var style = sectionStyles[title] ??
                              {
                                'icon': Icons.description,
                                'color': Colors.grey.shade200,
                                'iconColor': Colors.grey
                              };

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: style['color'],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(style['icon'],
                                        color: style['iconColor'], size: 28),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: style['iconColor'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...buildContentWidgets(content),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A6FE8),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoadmapScreen(
                                  careerName: recommendedCareerName,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "View Roadmap",
                            style:
                            TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[350],
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const QuizScreen()),
                            );
                          },
                          child: const Text(
                            "Retake Quiz",
                            style:
                            TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}