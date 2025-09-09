import 'package:flutter/material.dart';
import 'package:guidey/services/gemini_services.dart';
import 'roadmap_screen.dart'; // استيراد صفحة الرودماب

class CareerSearchPage extends StatefulWidget {
  @override
  _CareerSearchPageState createState() => _CareerSearchPageState();
}

class _CareerSearchPageState extends State<CareerSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  String roadmap = '';
  bool isLoading = false;

  void _getRoadmap() async {
    final careerField = _controller.text.trim();
    if (careerField.isEmpty) return;

    setState(() {
      isLoading = true;
      roadmap = '';
    });

    try {
      final result = await _geminiService.getCareerRoadmap(careerField);
      setState(() {
        roadmap = result;
      });

      // بعد ما نجحنا في الحصول على الرودماب، ننتقل للصفحة الجديدة ونمرر البيانات
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoadmapScreen(
            careerName: careerField,
            roadmapData: roadmap,
          ),
        ),
      );

    } catch (e) {
      setState(() {
        roadmap = '❌ فشل في الحصول على الخريطة. حاول مرة أخرى.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Your Way',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Find your roadmap',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Enter Career Field",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: isLoading ? null : _getRoadmap,
                  child: Text(isLoading ? "Loading..." : "Get Roadmap"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}