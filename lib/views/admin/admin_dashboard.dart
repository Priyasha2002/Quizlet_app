import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/admin_screen.dart';



class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    questionController.loadQestionCategoryFromSharedPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(AdminScreen(
                        quizCategory: controller.savedCategories[index]));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(controller.savedCategories[index]),
                  subtitle: Text(controller.savedSubtitle[index]),
                  trailing: IconButton(
                    onPressed: () {
                      _showDeleteDialog(controller.savedCategories[index]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  _showDialogBox() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            controller: questionController.categoryTitleController,
            decoration:
            const InputDecoration(hintText: "Enter the category name"),
          ),
          TextFormField(
            controller: questionController.categorySubtitleController,
            decoration:
            const InputDecoration(hintText: "Enter the category subtitle"),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        questionController.savedQuestionCategoryToSharedPrefrences();
        Get.back();
      },
    );
  }

  void _showDeleteDialog(String category) {
    Get.defaultDialog(
      title: "Delete Category",
      content: Text("Are you sure you want to delete the category '$category'?"),
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () {
        questionController.deleteCategory(category);
        Get.back();

      },
    );
  }

}



