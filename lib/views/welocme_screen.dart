import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/utils/constants.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/admin_dashboard.dart';
import 'package:quiz_application_tut_from_scracth/views/quiz_category.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

class WelcomeScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Quizlet",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white
          ),
        ),
          centerTitle: true,
          gradient: LinearGradient(
            colors: [Color(0xFF46A0Ae), Color(0xFF00FFCB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/bg.svg",
            fit: BoxFit.fitWidth,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    "Let's Play Quiz",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const Text("Check your IQ with Quizlet"),
                  const Spacer(), // /1/6
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2341),
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      final userName = userNameController.text;
                      if (userName == "Admin" || userName == "admin") {
                        Get.to(
                          const AdminDashboard(),
                        );
                      } else {
                        Get.to(
                          QuizCategoryScreen(),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                      decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Let's Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),

                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
