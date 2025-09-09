class Question {
  final int id;
  final String question;
  final List<String> options;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
  });
}

final List<Question> questions = [
  Question(
    id: 1,
    question: "Which activities do you find most engaging?",
    options: [
      "Building and creating things",
      "Analyzing data and solving problems",
      "Helping and teaching others",
      "Designing and expressing creativity"
    ],
    category: 'interests',
  ),
  Question(
    id: 2,
    question: "How do you prefer to work?",
    options: [
      "In a team with lots of collaboration",
      "Independently with minimal supervision",
      "Leading and managing others",
      "Following clear processes and guidelines"
    ],
    category: 'work_style',
  ),
  Question(
    id: 3,
    question: "What motivates you most in a career?",
    options: [
      "High salary and financial security",
      "Making a positive impact on society",
      "Continuous learning and growth",
      "Recognition and status"
    ],
    category: 'personality',
  ),
  Question(
    id: 4,
    question: "Which skills come naturally to you?",
    options: [
      "Technical and analytical thinking",
      "Communication and interpersonal skills",
      "Creative and artistic abilities",
      "Leadership and organization"
    ],
    category: 'skills',
  ),
  Question(
    id: 5,
    question: "What type of problems do you enjoy solving?",
    options: [
      "Technical challenges and debugging",
      "Human behavior and psychology",
      "Design and user experience",
      "Business strategy and optimization"
    ],
    category: 'interests',
  ),
  Question(
    id: 6,
    question: "Which work environment appeals to you?",
    options: [
      "Fast-paced startup with flexibility",
      "Stable corporate environment",
      "Remote work with global teams",
      "On-site collaborative spaces"
    ],
    category: 'work_style',
  ),
  Question(
    id: 7,
    question: "How do you handle stress and pressure?",
    options: [
      "I thrive under pressure and deadlines",
      "I prefer steady, predictable workloads",
      "I work best with clear support systems",
      "I need time to process and reflect"
    ],
    category: 'personality',
  ),
  Question(
    id: 8,
    question: "Which subjects interested you most in school?",
    options: [
      "Mathematics and Science",
      "Literature and Social Studies",
      "Art and Creative subjects",
      "Business and Economics"
    ],
    category: 'interests',
  ),
  Question(
    id: 9,
    question: "When learning something new, which best describes you?",
    options: [
      "I enjoy breaking it into small logical steps",
      "I need to understand the -why- behind it",
      "I prefer jumping in and learning by doing",
      "I look for real-world examples to connect it with"
    ],
    category: 'interests',
  ),
  Question(
    id: 10,
    question: "Which describes how you approach problems?",
    options: [
      "I test solutions quickly and see what works",
      "I read and plan before taking action",
      "I talk to people and collect input first",
      "I analyze previous cases to avoid mistakes"
    ],
    category: 'work_style',
  ),
  Question(
    id: 11,
    question: "You’re given a project deadline. What’s your focus?",
    options: [
      "Quality of the result",
      "Creative uniqueness",
      "User satisfaction",
      "Efficiency and delivery"
    ],
    category: 'work_style',
  ),
  Question(
    id: 12,
    question: "What would you rather learn?",
    options: [
      "How to automate a task",
      "How to edit videos or design posters",
      "How to run a marketing campaign",
      "How to improve team collaboration"
    ],
    category: 'work_style',
  ),
  Question(
    id: 13,
    question: "If you're stuck in a new challenge, you:",
    options: [
      "Look for online solutions or ask ChatGPT",
      "Try different approaches until something works",
      "Ask someone with experience",
      "Step back and rethink the whole idea"
    ],
    category: 'personality',
  ),
  Question(
    id: 14,
    question: "How do you feel about routine work?",
    options: [
      "I prefer complex tasks that require thinking",
      "I’m okay with it if it helps the bigger plan",
      "I avoid routine – I like change and creativity",
      "Routine is fine if I’m helping someone"
    ],
    category: 'work_style',
  ),
  Question(
    id: 15,
    question: "Which of these quotes do you relate to most?",
    options: [
      "Everything is figureoutable",
      "Fail fast, learn faster",
      "Creativity is intelligence having fun.",
      "People will forget what you said,\nbut never how you made them feel."
    ],
    category: 'personality',
  ),
];