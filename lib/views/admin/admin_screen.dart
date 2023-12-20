import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/models/questions_model.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;
  AdminScreen({super.key, required this.quizCategory});
  final QuestionController questionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to $quizCategory"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: questionController.questionContorllerText,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              for (var i = 0; i < 4; i++)
                TextFormField(
                  controller: questionController.optionControllers[i],
                  decoration: InputDecoration(labelText: "Options ${i + 1}"),
                ),
              TextFormField(
                controller: questionController.correctAnswerController,
                decoration:
                const InputDecoration(labelText: "Correct Answers (0 -3)"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (questionController
                        .questionContorllerText.text.isEmpty) {
                      Get.snackbar("Required", "All Fields are Required");
                    } else if (questionController
                        .optionControllers[0].text.isEmpty) {
                      Get.snackbar("Required", "All Fields are Required");
                    } else if (questionController
                        .optionControllers[1].text.isEmpty) {
                      Get.snackbar("Required", "All Fields are Required");
                    } else if (questionController
                        .optionControllers[2].text.isEmpty) {
                      Get.snackbar("Required", "All Fields are Required");
                    } else if (questionController
                        .optionControllers[3].text.isEmpty) {
                      Get.snackbar("Required", "All Fields are Required");
                    } else {
                      addQuestions();
                    }
                  },
                  child: const Text("Add Questions"))
            ],
          ),
        ),
      ),
    );
  }

  void addQuestions() async {
    //collecting questions from the text Controllers
    final String questionText = questionController.questionContorllerText.text;
    final List<String> options = questionController.optionControllers
        .map((controller) => controller.text)
        .toList();

    final int correctAnswer =
        int.tryParse(questionController.correctAnswerController.text) ?? 1;

    //Creating a new Question instance
    final Question newQuestion = Question(
      category: quizCategory,
      id: DateTime.now().microsecondsSinceEpoch, //Unique
      questions: questionText,
      options: options,
      answer: correctAnswer,
    );

    //Save the question to SharedPrefrences
    await questionController.saveQuestionToSharedPrefrences(newQuestion);

    Get.snackbar("Added", "Question Added");
    questionController.questionContorllerText.clear();
    questionController.optionControllers.forEach((element) {
      element.clear();
    });
  }
}
