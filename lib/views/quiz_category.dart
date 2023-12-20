import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/views/quiz_screen.dart';

class QuizCategoryScreen extends StatelessWidget {
  QuizCategoryScreen({super.key});

  final QuestionController _questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/bg.svg",
            fit: BoxFit.fitWidth,
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _questionController.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: GestureDetector(
                  onTap: () {
                    Get.to(QuizScreen(
                      category: _questionController.savedCategories[index],
                    ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.question_answer),
                      Text(_questionController.savedCategories[index]),
                      Text(_questionController.savedSubtitle[index])
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
