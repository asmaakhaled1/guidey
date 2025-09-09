import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:http/http.dart' as http;
final String apiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

class GeminiService {
  final String apiKey = "AIzaSyDriD3Y8_qxDPEi7GVErhTbArhm4hssz-4";

  Future<String> getCareerResult(
      List<Question> questions,
      List<String> answers,
      ) async {
    try {
      final promptBuffer = StringBuffer();
      for (int i = 0; i < questions.length; i++) {
        promptBuffer.writeln("Q${i + 1}: ${questions[i].question}");
        promptBuffer.writeln("Answer: ${answers[i]}");
        promptBuffer.writeln("");
      }

      final prompt =
      """
You are an AI career advisor. Based on the following user responses, provide a structured career recommendation.

User Responses:
${promptBuffer.toString()}

Format your answer exactly like this:

## Recommended Career
[Write the career title here]


## Why This Career Fits You
[Explain briefly why this career is suitable based on the user's answers]


## Required Skills
[List 5-7 key skills needed for this career]


## Steps to Get Started
[Provide 3-5 practical steps the user should take to start in this career]


## Additional Advice
[Provide any tips or encouragement for the user]


Keep the language clear, friendly, and motivational.
""";

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? 'No response from Gemini.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getCareerRoadmap(String careerTitle) async {
    try {
      final prompt = """
You are an expert career mentor.
Create a step-by-step learning roadmap for becoming a successful $careerTitle, starting from absolute beginner to advanced.
Split it into *three levels*: Beginner, Intermediate, Advanced.
For each level, include:
- 3 key learning topics
- 3 recommended resources (URL links if possible)

Format exactly like this:

## Beginner
*Topics:*
1. ...
2. ...
3. ...

*Resources:*
1. ...
2. ...
3. ...

## Intermediate
*Topics:*
...

## Advanced
*Topics:*
...

Keep it concise, clear, and practical.
      """;

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
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
        return text ?? 'No roadmap generated.';
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting roadmap: $e');
    }
  }

}