import 'package:flutter/material.dart';

class JobsScreen extends StatefulWidget {
  @override
  State<JobsScreen> createState() => _JobsScreen();
}

class _JobsScreen extends State<JobsScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['All', 'Internships', 'Entry Level', 'Scholarships', 'Events'];


  final opportunities = [
    OpportunityModel(
      title: 'Software Engineering Internship',
      company: 'Google',
      description: 'Join our team to build innovative products that impact billions of users worldwide.',
      location: 'Mountain View, CA',
      salary: '\$8,000/month',
      duration: '12 weeks',
      deadline: 'Apply by Mar 15, 2025',
      requirements: ['Computer Science student', 'Python/Java proficiency', 'Data structures knowledge'],
      type: OpportunityType.internships,
      featured: true,
      icon: Icons.business_center_outlined,
      color: Colors.deepPurpleAccent,
    ),
    OpportunityModel(
      title: 'UX Design Scholarship',
      company: 'Adobe Foundation',
      description: 'Supporting underrepresented students pursuing careers in design and creativity.',
      location: 'Worldwide (Remote)',
      salary: '\$10,000',
      deadline: 'Apply by Apr 1, 2025',
      requirements: ['Design portfolio', 'Undergraduate student', 'Financial need demonstration'],
      type: OpportunityType.scholarships,
      featured: true,
      icon: Icons.school_outlined,
      color: Colors.orange,
    ),
    OpportunityModel(
      title: 'Junior Data Analyst',
      company: 'Microsoft',
      description: 'Analyze data to drive business decisions and create actionable insights.',
      location: 'Seattle, WA (Remote)',
      salary: '\$75,000 - \$95,000',
      requirements: ['Bachelor\'s degree', 'SQL proficiency', 'Excel/Power BI experience'],
      type: OpportunityType.entryLevel,
      icon: Icons.analytics_outlined,
      color: Colors.green,
    ),
    OpportunityModel(
      title: 'Frontend Developer Internship',
      company: 'Netflix',
      description: 'Build user interfaces for our streaming platform used by millions globally.',
      location: 'Los Gatos, CA',
      salary: '\$7,500/month',
      duration: '10 weeks',
      deadline: 'Apply by Mar 20, 2025',
      requirements: ['React.js experience', 'JavaScript proficiency', 'Portfolio of projects'],
      type: OpportunityType.internships,
      featured: true,
      icon: Icons.code,
      color: Colors.deepPurpleAccent,
    ),
    OpportunityModel(
      title: 'Digital Marketing Associate',
      company: 'Spotify',
      description: 'Drive user acquisition and engagement through digital marketing campaigns.',
      location: 'New York, NY (Remote)',
      salary: '\$55,000 - \$70,000',
      requirements: ['Marketing degree', 'Google Analytics', 'Social media expertise'],
      type: OpportunityType.entryLevel,
      icon: Icons.campaign,
      color: Colors.green,
    ),


    OpportunityModel(
      title: 'AI Career Conference 2025',
      company: 'TechCareers',
      description: 'Network with industry professionals and learn about AI career opportunities.',
      location: 'San Francisco, CA',
      deadline: 'Apply by Feb 28, 2025',
      requirements: ['Student ID', 'Interest in AI/ML'],
      type: OpportunityType.event,
      icon: Icons.event,
      color: Colors.red,
    ),
  ];

  List<OpportunityModel> get filteredOpportunities {
    if (selectedTabIndex == 0) return opportunities;
    return opportunities.where((opp) {
      switch (selectedTabIndex) {
        case 1: return opp.type == OpportunityType.internships;
        case 2: return opp.type == OpportunityType.entryLevel;
        case 3: return opp.type == OpportunityType.scholarships;
        case 4: return opp.type == OpportunityType.event;
        default: return true;
      }
    }).toList();
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
                Text('Career Opportunities',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Find internships, jobs and scholarships',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search opportunities...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedTabIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(right: 16 , top: 22),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedTabIndex == index ? Color(0xFF8B5FE6) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(tabs[index],
                        style: TextStyle(
                          color: selectedTabIndex == index ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: filteredOpportunities.length,
              itemBuilder: (context, index) {
                final opp = filteredOpportunities[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: opp.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(opp.icon, color: opp.color, size: 24),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(opp.title,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ),
                                    if (opp.featured)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text('FEATURED',
                                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                  ],
                                ),
                                Text(opp.company,
                                    style: TextStyle(color: Color(0xFF8B5FE6), fontSize: 14, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(opp.description,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      SizedBox(height: 15),
                      if (opp.location != null) _buildInfoRow(Icons.location_on, opp.location!),
                      if (opp.salary != null) _buildInfoRow(Icons.attach_money, opp.salary!),
                      if (opp.duration != null) _buildInfoRow(Icons.access_time, opp.duration!),
                      if (opp.deadline != null) _buildInfoRow(Icons.event, opp.deadline!),
                      SizedBox(height: 15),
                      Text('Requirements:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 8),
                      ...opp.requirements.map((req) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                            ),
                            SizedBox(width: 10),
                            Text(req, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          ],
                        ),
                      )),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: opp.type == OpportunityType.scholarships ? Colors.orange :
                            opp.type == OpportunityType.entryLevel ? Colors.green :
                            opp.type == OpportunityType.event ? Colors.red : Color(0xFF8B5FE6),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text(
                            opp.type == OpportunityType.event ? 'Learn More' : 'Apply Now',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        ],
      ),
    );
  }
}

enum OpportunityType { internships, entryLevel, scholarships, event }
class OpportunityModel {
  final String title;
  final String company;
  final String description;
  final String? location;
  final String? salary;
  final String? duration;
  final String? deadline;
  final List<String> requirements;
  final OpportunityType type;
  final bool featured;
  final IconData icon;
  final Color color;

  OpportunityModel({
    required this.title,
    required this.company,
    required this.description,
    this.location,
    this.salary,
    this.duration,
    this.deadline,
    required this.requirements,
    required this.type,
    this.featured = false,
    required this.icon,
    required this.color,
  });
}
