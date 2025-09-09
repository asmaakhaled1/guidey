import 'package:flutter/material.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:guidey/quiz/quiz_page.dart';
import 'package:guidey/roadmap_screen.dart';
import 'package:guidey/services/gemini_services.dart';
import 'package:guidey/quiz/lang_prov.dart';
import 'package:provider/provider.dart';

class Specialization {
  final String name;
  final String percentage;

  Specialization(this.name, this.percentage);
}

class ResultScreen extends StatelessWidget {
  final List<Question> questions;
  final List<String> answers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  String cleanMarkdown(String text) {
    return text.replaceAll(RegExp(r'[_`~*]'), '').trim();
  }

  List<Widget> buildContentWidgets(String content) {
    final widgets = <Widget>[];
    final lines = content
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();

    for (var line in lines) {
      final cleanLine = cleanMarkdown(line);

      if (cleanLine.startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    cleanLine.substring(2),
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (RegExp(r'^\d+.').hasMatch(cleanLine)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cleanLine.split('.').first}. ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    cleanLine.substring(cleanLine.indexOf('.') + 1).trim(),
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              cleanLine,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();

    final sectionStyles = {
      'Recommended Career Category': {
        'icon': Icons.work,
        'color': Colors.blue.shade50,
        'iconColor': Colors.blue,
      },
      'Why This Career Category Fits You': {
        'icon': Icons.favorite,
        'color': Colors.purple.shade50,
        'iconColor': Colors.purple,
      },
      'Possible Specializations & Fit Percentage': {
        'icon': Icons.bar_chart,
        'color': Colors.teal.shade50,
        'iconColor': Colors.teal,
      },
      'Required Core Skills': {
        'icon': Icons.build,
        'color': Colors.orange.shade50,
        'iconColor': Colors.orange,
      },
      'Steps to Get Started': {
        'icon': Icons.rocket_launch,
        'color': Colors.green.shade50,
        'iconColor': Colors.green,
      },
      'Additional Advice': {
        'icon': Icons.lightbulb,
        'color': Colors.yellow.shade50,
        'iconColor': Colors.amber[800],
      },
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
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
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: FutureBuilder<String>(
        future: GeminiService(
          langProvider: langProvider,
        ).getCareerResult(questions, answers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8A6FE8)),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data ?? 'No result found';
            final sections = data
                .split('##')
                .where((s) => s.trim().isNotEmpty)
                .toList();

            String specialization1 = "";
            String specialization2 = "";
            String specialization3 = "";

            for (var section in sections) {
              if (section.trim().startsWith('Possible Specializations')) {
                final lines = section.trim().split('\n').skip(1).toList();
                int count = 0;
                for (var line in lines) {
                  if (line.trim().isNotEmpty && line.contains('–')) {
                    final parts = line.split('–');
                    if (parts.isNotEmpty) {
                      count++;
                      if (count == 1) {
                        specialization1 = cleanMarkdown(parts[0].trim());
                      }
                      if (count == 2) {
                        specialization2 = cleanMarkdown(parts[0].trim());
                      }
                      if (count == 3) {
                        specialization3 = cleanMarkdown(parts[0].trim());
                      }
                    }
                  }
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
                      maxScale: 2,
                      child: ListView(
                        children: [
                          ...List.generate(sections.length, (index) {
                            final lines = sections[index].trim().split('\n');
                            final title = lines.first.trim();
                            final content = lines.skip(1).join('\n').trim();

                            final style =
                                sectionStyles[title] ??
                                {
                                  'icon': Icons.description,
                                  'color': Colors.grey.shade100,
                                  'iconColor': Colors.grey[700],
                                };

                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: style['color'] as Color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.07),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            (style['iconColor'] as Color)
                                                .withOpacity(0.1),
                                        child: Icon(
                                          style['icon'] as IconData,
                                          color: style['iconColor'] as Color,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            color: style["iconColor"] as Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...buildContentWidgets(content),
                                ],
                              ),
                            );
                          }),

                          if (specialization1.isNotEmpty)
                            buildSpecializationCard(context, specialization1),
                          if (specialization2.isNotEmpty)
                            buildSpecializationCard(context, specialization2),
                          if (specialization3.isNotEmpty)
                            buildSpecializationCard(context, specialization3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF8A6FE8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const QuizScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "🔄 Retake Quiz",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8A6FE8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

Widget buildSpecializationCard(BuildContext context, String specialization) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.teal.shade50,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          specialization,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3DAEE9),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoadmapScreen(careerName: specialization),
                ),
              );
            },
            child: const Text(
              "Get Roadmap",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
