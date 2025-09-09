import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:guidey/quiz/lang_prov.dart';

final String apiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

class GeminiService {
  final String apiKey = "AIzaSyAi4nZCXKRLg6h7RBpFV_PKppkrGNRn-20";
  final LanguageProvider? langProvider;

  GeminiService({this.langProvider});

  Future<String> getCareerResult(List<Question> questions, List<String> answers) async {
    return await compute(_generateCareerResult, {
      'questions': questions,
      'answers': answers,
      'apiKey': apiKey,
      'langMap': langProvider?.currentLang ?? {},
    });
  }

  Future<bool> testGeminiConnection() async {
    try {
      print('🧪 Testing Gemini API connection...');

      final testPrompt = "Hello, please respond with 'Test successful'";

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": testPrompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text != null && text.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ Gemini API test error: $e');
      return false;
    }
  }

  Future<String> getCareerRoadmap(String careerTitle) async {
    try {
      print('🚀 Generating roadmap for career: $careerTitle');


      final prompt = """
You are an expert career mentor. 
Your task is to create a structured learning roadmap for becoming a successful $careerTitle. 

⚠ Follow these rules STRICTLY:
- Output MUST contain exactly 3 levels: Beginner, Intermediate, Advanced.
- Each level MUST have 3 sections: Topics, Resources, Projects.
- Each section MUST contain EXACTLY 3 numbered items.
- Do NOT skip or merge any section.
- Use the exact headings and format as shown below.

## Beginner Level
Topics:
1. First fundamental concept
2. Second fundamental concept  
3. Third fundamental concept

Resources:
1. Free online course or tutorial link
2. Documentation or guide link
3. Practice website or tool link

Projects:
1. Simple beginner project
2. Another beginner project
3. Third practice project

## Intermediate Level  
Topics:
1. More advanced concept
2. Second intermediate concept
3. Third intermediate concept

Resources:
1. Intermediate course link
2. Advanced tutorial link
3. Professional documentation link

Projects:
1. Medium complexity project
2. Real-world application project
3. Portfolio project

## Advanced Level
Topics:
1. Expert level concept
2. Professional best practices
3. Industry standards

Resources:
1. Expert level course
2. Professional certification link
3. Industry documentation

Projects:
1. Advanced real-world project
2. Open source contribution
3. Professional portfolio project

⚠ If you cannot provide a real link, still write a placeholder like (Resource link here).
""";

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text != null && text.isNotEmpty) {
          return text;
        } else {
          throw Exception('No roadmap content received from Gemini API');
        }
      } else {
        throw Exception('Gemini API failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting roadmap: $e');
    }
  }
}


Future<String> _generateCareerResult(Map<String, dynamic> data) async {
  try {
    final questions = data['questions'] as List<Question>;
    final answers = data['answers'] as List<String>;
    final apiKey = data['apiKey'] as String;
    final langMap = data['langMap'] as Map<String, String>;

    final promptBuffer = StringBuffer();
    for (int i = 0; i < questions.length; i++) {
      final questionText = langMap[questions[i].questionKey] ?? questions[i].questionKey;
      final answerText = langMap[answers[i]] ?? answers[i];
      promptBuffer.writeln("Q${i + 1}: $questionText");
      promptBuffer.writeln("Answer: $answerText");
      promptBuffer.writeln("");
    }

    final prompt = """
You are an AI career advisor. Based on the following user responses, provide a structured career recommendation.

User Responses:
${promptBuffer.toString()}

Format your answer exactly like this:

## Recommended Career Category
[Write the broad career field here, e.g.,"Business & Commerce" instead of just "Accounting" , "Software Engineering" instead of just "Frontend Developer", etc]

## Why This Career Category Fits You
[Explain briefly why this general field suits the user’s answers]

## Possible Specializations & Fit Percentage
[List top 3 subfields under this career category, and provide a percentage that shows how well the user matches each. 
Example:
- Frontend Development – 80%
- Backend Development – 70%
- Data Engineering – 65% 
]

## Required Core Skills
[List 5-7 foundational skills needed across this career category]

## Steps to Get Started
[Provide 3-5 practical steps the user should take to begin exploring this field]

## Additional Advice
[Provide tips, motivation, and encouragement for exploring the specializations that best match the user’s profile]
""";


    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No response from Gemini.';
  } catch (e) {
    return 'Error: $e';
  }
}