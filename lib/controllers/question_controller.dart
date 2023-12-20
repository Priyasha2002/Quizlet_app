import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/models/questions_model.dart';
import 'package:quiz_application_tut_from_scracth/views/score_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {



  //User Interface Codes
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  late PageController _pageController;
  PageController get pageController => _pageController;
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAnd => _selectedAns;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  //Admin Screen
  List<Question> _questions = [];
  List<Question> get questions => _questions;

  List<Question> _filteredQuestion = [];
  List<Question> get filteredQuestion => _filteredQuestion;
  final TextEditingController questionContorllerText = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  Future<void> saveQuestionToSharedPrefrences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];

    //Convert the questions list to save it into sharedPrfrenes
    questions.add(jsonEncode(question.toJson()));
    await prefs.setStringList("questions", questions);
  }

  //Admin Dashboard
  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void savedQuestionCategoryToSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(categoryTitleController.text);
    savedSubtitle.add(categorySubtitleController.text);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);

    categorySubtitleController.clear();
    categoryTitleController.clear();
    Get.snackbar("Saved", "Category created successfully");
  }


  void deleteCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();

    savedCategories.remove(category);
    savedSubtitle.remove(category);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);
    update();


  }

  void loadQestionCategoryFromSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    final catagories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];

    savedCategories.assignAll(catagories);
    savedSubtitle.assignAll(subtitles);
    update();
  }

  void loadQuestionsFromSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions") ?? [];

    _questions = questionJson
        .map((json) => Question.fromJson(jsonDecode(json)))
        .toList();
    update();
  }

  List<Question> getQuestionsByCategory(String category) {
    return _questions
        .where((question) => question.category == category)
        .toList();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;
    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() async {
    if (_questionNumber.value != filteredQuestion.length) {
      _isAnswered = false;

      _pageController.nextPage(
        duration: const Duration(microseconds: 250),
        curve: Curves.ease,
      );

      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(const ScorePage());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }

  void setFilteredQuestions(String category) {
    _filteredQuestion = getQuestionsByCategory(category);
    _questionNumber.value = 1;
    update();
    nextQuestion();
  }

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });
    _animationController.forward().whenComplete(nextQuestion);
    loadQestionCategoryFromSharedPrefrences();
    loadQuestionsFromSharedPrefrences();
    _pageController = PageController();
    update();

    super.onInit();
  }
}
