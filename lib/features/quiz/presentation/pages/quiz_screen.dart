import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_text_styles.dart';
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
      "explanation": "StatelessWidget cannot change after it is built.",
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
      "explanation": "API stands for Application Programming Interface.",
    },
  ];

  int current = 0;
  List<int> selected = [];
  bool answered = false;
  int score = 0;

  void toggleAnswer(int index) {
    if (answered) return;

    setState(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
      }
    });
  }

  void confirmAnswer() {
    if (answered || selected.isEmpty) return;

    final correct = questions[current]["correct"];

    setState(() {
      answered = true;

      if (selected.contains(correct)) {
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
      selected = [];
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    final primary = Theme.of(context).primaryColor;
    final progress = (current + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.quiz_outlined),
            const SizedBox(width: 8),
            Text("Quiz", style: AppTextStyles.h3),
          ],
        ),
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
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${current + 1}/${questions.length}",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(.08),
                    primary.withOpacity(.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: primary.withOpacity(.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Question ${current + 1}",
                      style: AppTextStyles.label.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    q["question"],
                    style: AppTextStyles.h3.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: q["answers"].length,
                itemBuilder: (context, index) {
                  final correct = q["correct"];

                  Color bg = Colors.white;
                  Color border = Colors.transparent;
                  IconData? icon;

                  if (answered) {
                    if (index == correct) {
                      bg = Colors.green.shade50;
                      border = Colors.green;
                      icon = Icons.check_circle;
                    }

                    if (selected.contains(index) && index != correct) {
                      bg = Colors.red.shade50;
                      border = Colors.red;
                      icon = Icons.cancel;
                    }
                  } else {
                    if (selected.contains(index)) {
                      border = primary;
                    }
                  }

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => toggleAnswer(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: primary.withOpacity(0.1),
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              q["answers"][index],
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (icon != null)
                            Icon(
                              icon,
                              color:
                                  index == correct ? Colors.green : Colors.red,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!answered)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selected.isEmpty ? null : confirmAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Confirm Answer"),
                ),
              ),
            if (answered)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber.withOpacity(.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      q["explanation"],
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
            if (answered)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: nextQuestion,
                  icon: Icon(
                    current == questions.length - 1
                        ? Icons.flag
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    current == questions.length - 1
                        ? "Finish Quiz"
                        : "Next Question",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}