import 'package:opinion_easy/data/model/question_model.dart';
import 'package:opinion_easy/data/service/ques_ans_service.dart';
import 'package:opinion_easy/data/service/internet_monitor.dart';
import 'package:opinion_easy/view/home/widgets/confirm_answer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/admob/admob.dart';

class QuestionController extends GetxController {
  final QuestionService questionService = QuestionService();
  final PageController pageController = PageController();

  var isLoading = true.obs;
  var questions = <Question>[].obs;
  var currentIndex = 0.obs;
  var isSubmitting = false.obs;
  var answeredQuestionsCount = 0.obs;

  @override
  void onClose() {
    currentIndex.value = 0;
    answeredQuestionsCount.value = 0;
    questions.clear();

    if (pageController.hasClients) pageController.jumpToPage(0);
    pageController.dispose();
    super.onClose();
  }

  // ── Data ───────────────────────────────────────────────────

  Future<void> fetchQuestions(String subCategName, String subCategId) async {
    try {
      isLoading(true);

      // Reset before loading new set
      currentIndex.value = 0;
      answeredQuestionsCount.value = 0;
      questions.clear();
      if (pageController.hasClients) pageController.jumpToPage(0);

      final data = await questionService.fetchQuestion(subCategId);
      questions.assignAll(data);
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar("Error", "Failed to load questions");
    } finally {
      isLoading(false);
    }
  }

  // ── Confirm dialog ─────────────────────────────────────────

  /// Opens [ConfirmAnswerDialog]. All ad logic lives inside that widget.
  void confirmSubmission(String answer) {
    if (isSubmitting.value) return;

    final question = questions[currentIndex.value];

    ConfirmAnswerDialog.show(
      answer: answer,
      question: question,
      onConfirm: (ans) => submitAnswer(ans),
      onCancel: () {}, // dialog already closed itself
    );
  }

  // ── Navigation ─────────────────────────────────────────────

  bool _shouldShowInterstitial() =>
      answeredQuestionsCount.value % 2 == 0 && answeredQuestionsCount.value > 0;

  void _moveToNextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed('/thank-you');
    }
  }

  void nextQuestion({bool isSkipped = false}) {
    // Close dialog if still open (e.g. called via skip)
    if (Get.isDialogOpen ?? false) Get.back();

    if (_shouldShowInterstitial() && !isSkipped) {
      AdService.to.showInterstitial(
        onComplete: _moveToNextQuestion,
      );
    } else {
      _moveToNextQuestion();
    }
  }

  void previousQuestion() {
    if (Get.isDialogOpen ?? false) Get.back();
    if (currentIndex.value > 0) {
      currentIndex.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ── Submit ─────────────────────────────────────────────────

  Future<void> submitAnswer(String answer) async {
    if (isSubmitting.value) return;

    final currentQuestion = questions[currentIndex.value];
    isSubmitting.value = true;

    try {
      final response = await questionService.submitAnswer(
        currentQuestion.id,
        answer,
      );

      if (response["status"] == "success") {
        answeredQuestionsCount.value++;

        Get.snackbar(
          "Success",
          response["message"] ?? "Answer submitted!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );

        await Future.delayed(const Duration(milliseconds: 1200));
        nextQuestion();
      } else {
        Get.snackbar("Oops", response['message'] ?? "Failed to submit answer");
      }
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
