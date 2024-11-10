import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'quiz_question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final ApiService apiService;

  QuizScreen({required this.apiService});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  String userAnswer = '';
  bool isCorrect = false;

  late Future<List<QuizQuestion>> quizQuestionsFuture;

  @override
  void initState() {
    super.initState();
    quizQuestionsFuture = widget.apiService.getQuizQuestions();
  }

  void checkAnswer(String answer, List<QuizQuestion> questions) {
    setState(() {
      isAnswered = true;
      userAnswer = answer;
      isCorrect = answer == questions[currentQuestionIndex].answer;
      if (isCorrect) score++;
    });
  }

  void nextQuestion(List<QuizQuestion> questions) {
    if (currentQuestionIndex + 1 < questions.length) {
      setState(() {
        isAnswered = false;
        userAnswer = '';
        currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: score, total: questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bac.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
          ),
        ),
        child: FutureBuilder<List<QuizQuestion>>(
          future: quizQuestionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No questions available'));
            }

            final questions = snapshot.data!;
            final question = questions[currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Circular Progress Indicator
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: (currentQuestionIndex + 1) / questions.length,
                          strokeWidth: 8,
                          backgroundColor:
                              const Color.fromARGB(255, 9, 122, 228),
                          color: Colors.deepPurple.shade500,
                        ),
                        Center(
                          child: Text(
                            "${currentQuestionIndex + 1} / ${questions.length}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Question Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Answer Options
                  Expanded(
                    child: ListView(
                      children: question.options.map((option) {
                        bool isSelected = isAnswered && option == userAnswer;
                        bool isCorrectAnswer =
                            isAnswered && option == question.answer;
                        return GestureDetector(
                          onTap: isAnswered
                              ? null
                              : () => checkAnswer(option, questions),
                          child: Card(
                            color: isSelected
                                ? (isCorrect
                                    ? Colors.greenAccent[200]
                                    : Colors.redAccent[200])
                                : Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (isAnswered)
                    Text(
                      isCorrect
                          ? 'صحيح!'
                          : 'خطأ! الإجابة الصحيحة هي ${question.answer}.',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.error,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade600,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () => nextQuestion(questions),
                    child:
                        Text('السؤال التالي', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
