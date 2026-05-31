import 'package:flutter/material.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is JSX in React?",
      "answers": [
        "A JavaScript extension for XML",
        "JavaScript XML - syntax extension that allows HTML-like code in JS",
        "A separate templating language",
        "A CSS-in-JS solution",
      ],
      "correct": 1,
      "explanation":
          "JSX is a syntax extension for JavaScript that lets you write HTML-like code inside JavaScript.",
    },
    {
      "question": "Which widget is immutable in Flutter?",
      "answers": [
        "StatefulWidget",
        "InheritedWidget",
        "StatelessWidget",
        "State",
      ],
      "correct": 2,
      "explanation":
          "StatelessWidget cannot change after it is built.",
    },
    {
      "question": "What does API stand for?",
      "answers": [
        "Application Programming Interface",
        "Advanced Program Integration",
        "Application Process Interface",
        "Automated Programming Input",
      ],
      "correct": 0,
      "explanation":
          "API stands for Application Programming Interface.",
    },
  ];

  int current = 0;
  int? selected;
  bool answered = false;
  int score = 0;

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selected = index;
      answered = true;

      if (index == questions[current]["correct"]) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (current == questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: score,
            total: questions.length,
          ),
        ),
      );
      return;
    }

    setState(() {
      current++;
      selected = null;
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    final primary = Theme.of(context).primaryColor;
    final progress = (current + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${current + 1}/${questions.length}",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Question ${current + 1}",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    q["question"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  final correct = q["correct"];

                  Color bg = Theme.of(context).colorScheme.surface;
                  Color border = Colors.transparent;
                  IconData? icon;

                  if (answered) {
                    if (index == correct) {
                      bg = Colors.green.shade50;
                      border = Colors.green;
                      icon = Icons.check_circle;
                    }

                    if (selected == index && index != correct) {
                      bg = Colors.red.shade50;
                      border = Colors.red;
                      icon = Icons.cancel;
                    }
                  }

                  return InkWell(
                    onTap: () => selectAnswer(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: border,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: primary.withOpacity(0.1),
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              q["answers"][index],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (icon != null)
                            Icon(
                              icon,
                              color: index == correct
                                  ? Colors.green
                                  : Colors.red,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (answered)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  q["explanation"],
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ),
            if (answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextQuestion,
                  child: Text(
                    current == questions.length - 1
                        ? "Finish Quiz"
                        : "Next Question",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}