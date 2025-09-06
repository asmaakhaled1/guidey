
class Question {
  final int id;
  final String questionKey;
  final List<String> optionKeys;
  final String category;

  Question({
    required this.id,
    required this.questionKey,
    required this.optionKeys,
    required this.category,
  });
}


final List<Question> questions = [
  Question(
    id: 1,
    questionKey: "q1",
    optionKeys: ["q1o1", "q1o2", "q1o3", "q1o4"],
    category: 'interests',
  ),
  Question(
    id: 2,
    questionKey: "q2",
    optionKeys: ["q2o1", "q2o2", "q2o3", "q2o4"],
    category: 'work_style',
  ),
  Question(
    id: 3,
    questionKey: "q3",
    optionKeys: ["q3o1", "q3o2", "q3o3", "q3o4"],
    category: 'personality',
  ),
  Question(
    id: 4,
    questionKey: "q4",
    optionKeys: ["q4o1", "q4o2", "q4o3", "q4o4"],
    category: 'skills',
  ),
  Question(
    id: 5,
    questionKey: "q5",
    optionKeys: ["q5o1", "q5o2", "q5o3", "q5o4"],
    category: 'interests',
  ),
  Question(
    id: 6,
    questionKey: "q6",
    optionKeys: ["q6o1", "q6o2", "q6o3", "q6o4"],
    category: 'work_style',
  ),
  Question(
    id: 7,
    questionKey: "q7",
    optionKeys: ["q7o1", "q7o2", "q7o3", "q7o4"],
    category: 'personality',
  ),
  Question(
    id: 8,
    questionKey: "q8",
    optionKeys: ["q8o1", "q8o2", "q8o3", "q8o4"],
    category: 'interests',
  ),
  Question(
    id: 9,
    questionKey: "q9",
    optionKeys: ["q9o1", "q9o2", "q9o3", "q9o4"],
    category: 'interests',
  ),
  Question(
    id: 10,
    questionKey: "q10",
    optionKeys: ["q10o1", "q10o2", "q10o3", "q10o4"],
    category: 'work_style',
  ),
  Question(
    id: 11,
    questionKey: "q11",
    optionKeys: ["q11o1", "q11o2", "q11o3", "q11o4"],
    category: 'work_style',
  ),
  Question(
    id: 12,
    questionKey: "q12",
    optionKeys: ["q12o1", "q12o2", "q12o3", "q12o4"],
    category: 'work_style',
  ),
  Question(
    id: 13,
    questionKey: "q13",
    optionKeys: ["q13o1", "q13o2", "q13o3", "q13o4"],
    category: 'personality',
  ),
  Question(
    id: 14,
    questionKey: "q14",
    optionKeys: ["q14o1", "q14o2", "q14o3", "q14o4"],
    category: 'work_style',
  ),
  Question(
    id: 15,
    questionKey: "q15",
    optionKeys: ["q15o1", "q15o2", "q15o3", "q15o4"],
    category: 'personality',
  ),
];