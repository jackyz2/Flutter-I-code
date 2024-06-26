import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/question_model.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/pages/learningpage.dart';
import 'package:flutter_application_1/pages/scorescreen.dart';

Future<List<Question>>? fetchedQuestions;
List<Question>? questions;
List<Image?> questionImages = [];

Future<List<Question>> fetchQuizQuestions() async {
  var refreshToken = await API.currentUserData.read(key: 'refreshToken');
  var data = {"refreshToken": refreshToken};
  return API.parseQ(data);
}



class ProgressBar extends StatefulWidget {
  final int currentIndex;
  final int totalQuestions;

  const ProgressBar({
    Key? key,
    required this.currentIndex,
    required this.totalQuestions,
  }) : super(key: key);

  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.currentIndex / widget.totalQuestions;
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.question,
    required this.isSelected,
    required this.currentIndex,
    required this.correctAnswer,
    required this.selectedAnswerIndex,
    required this.check
  });

  final String question;
  final bool isSelected;
  final String correctAnswer;
  final int? selectedAnswerIndex;
  final int currentIndex;
  final bool check;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = question == correctAnswer;
    bool isWrongAnswer = !isCorrectAnswer && isSelected;
    return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.lightBlue[200] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedAnswerIndex != null && check
                  ? isCorrectAnswer
                      ? Colors.green
                      : isWrongAnswer
                          ? Colors.red
                          : Colors.grey
                  : Colors.white,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              selectedAnswerIndex == null || !check
                  ? const SizedBox.shrink()
                  : isCorrectAnswer
                      ? buildCorrectIcon()
                      : isWrongAnswer
                          ? buildWrongIcon()
                          : const SizedBox.shrink(),
            ],
          ),
        ));
  }
}

Widget buildCorrectIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.green,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

Widget buildWrongIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.red,
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );

class QuizFetchScreen extends StatefulWidget {
  const QuizFetchScreen({super.key});
  @override
  State<QuizFetchScreen> createState() => _QuizFetchScreenState();
}

Future<void> imageListBuilder(List<Question>? questions) async {
    for(var question in questions!) {
      if(question.imageUrl != "") {
        Image? image = await API.parseImage(question.imageUrl);
        questionImages.add(image);
      } else {
        questionImages.add(null);
      }
    }
  }

Future<List<Question>?> fetchAndBuildQuiz() async {
  fetchedQuestions = fetchQuizQuestions();
  questions = await fetchedQuestions;
  await imageListBuilder(questions);
  return questions;
}

class _QuizFetchScreenState extends State<QuizFetchScreen> {


  @override
  Widget build(BuildContext context) {
    //final question = questions[0];
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 137, 188, 255), Color(0xFF0652C5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FutureBuilder<List<Question>?>(
        future: fetchAndBuildQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while the data is being fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something went wrong during the fetch
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Data is fetched successfully and the list is not empty
            //Question currQuestion = snapshot.data![questionIndex];
            //bool isLastQuestion = questionIndex == snapshot.data!.length - 1;
            questions = snapshot.data!;
            //imageListBuilder(questions);
            return QuizScreen();
          } else {
            // Handle the case where there is no data returned
            return Center(child: Text('No questions available'));
          }
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int idx = 0;
  int score = 0;
  bool checked = false;
  String buttonText = "Check Answer";
  @override
  Widget build(BuildContext context) {
    Question currQuestion = questions![questionIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ProgressBar(
              currentIndex: questionIndex, totalQuestions: questions!.length),
          Text(
            currQuestion.questionTitle,
            style: const TextStyle(fontSize: 25, color: Colors.white),
            textAlign: TextAlign.center,
          ),// Display the question
          if(questionImages[questionIndex] != null)
            Center(
              child: SizedBox(
                child: questionImages[questionIndex],
                height: 300,
                width: 300,
              )
            ),

          ListView.builder(
            shrinkWrap: true,
            itemCount: currQuestion.options.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedAnswerIndex == index;
              return GestureDetector(
                  onTap: checked
                      ? null
                      : () {
                          setState(() {
                            selectedAnswerIndex = index;
                          });
                        },
                  child: AnswerCard(
                    currentIndex: index,
                    question: currQuestion.options[index],
                    isSelected: isSelected,
                    selectedAnswerIndex: selectedAnswerIndex,
                    correctAnswer: currQuestion.answer,
                    check: checked
                  ));
            },
          ),
          const SizedBox(
            height: 30,
          ),
          AbsorbPointer(
            absorbing: selectedAnswerIndex == null,
            child: GestureDetector(
            onTap: !checked
                ? () {
                    if (selectedAnswerIndex != null) {
                      if (currQuestion.options[selectedAnswerIndex!] == currQuestion.answer) {
                        ++score;
                      }
                    }
                    setState(() {
                      checked = true;
                      buttonText = "Continue";
                    });
                  }
                : questionIndex == questions!.length - 1
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                                builder: (context) => ScoreScreen(score: score,)),
                        );
                      }
                    : () {
                        setState(() {
                          ++questionIndex;
                          selectedAnswerIndex = null;
                          buttonText = "Check Answer";
                          checked = false;
                          currQuestion = questions![questionIndex];
                        });
                      },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: selectedAnswerIndex == null ? Colors.grey[400] : Colors.lightBlue[200],
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          )
        ],
      ),
    )
   );

  }
}
