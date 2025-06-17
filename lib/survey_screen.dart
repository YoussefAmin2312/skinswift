import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'survey_page.dart';
import 'survey_question.dart';
import 'survey_data_service.dart';
import 'survey_results_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  late List<List<SurveyQuestion>> _surveyPages;
  late List<String?> _pageTitles;

  @override
  void initState() {
    super.initState();
    _surveyPages = SurveyDataService.getSurveyPages();
    _pageTitles = SurveyDataService.getPageTitles();
  }

  bool _isCurrentPageValid() {
    final currentQuestions = _surveyPages[_currentPageIndex];

    for (var question in currentQuestions) {
      if (!question.isAnswered) {
        return false;
      }
    }
    return true;
  }

  // This function will be called from SurveyPage when answers change
  void _onAnswerChanged() {
    setState(() {
      // This will trigger a rebuild and update the continue button state
    });
  }

  void _goToNextPage() {
    if (!_isCurrentPageValid()) {
      _showValidationMessage();
      return;
    }

    if (_currentPageIndex < _surveyPages.length - 1) {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // Survey completed
      _completeSurvey();
    }
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      HapticFeedback.lightImpact();

      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  void _showValidationMessage() {
    String message;
    final currentQuestions = _surveyPages[_currentPageIndex];

    // Check what type of validation failed
    bool hasSelection = currentQuestions.any((q) => q.type == QuestionType.selectionType);
    bool hasMultiSelection = currentQuestions.any((q) => q.type == QuestionType.multiSelectionType);

    if (hasMultiSelection) {
      message = 'Please select at least one option to continue.';
    } else if (hasSelection) {
      message = 'Please select an option to continue.';
    } else {
      message = 'Please complete all questions to continue.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _completeSurvey() {
    // Add completion haptic feedback
    HapticFeedback.mediumImpact();

    // Log survey results for debugging (remove in production)
    _logSurveyResults();

    // Navigate to results screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SurveyResultsScreen(
          surveyData: _surveyPages,
        ),
      ),
    );
  }

  void _logSurveyResults() {
    // Use debugPrint instead of print for better debugging
    debugPrint("=== SURVEY COMPLETED ===");
    for (int pageIndex = 0; pageIndex < _surveyPages.length; pageIndex++) {
      debugPrint("Page ${pageIndex + 1}:");
      for (var question in _surveyPages[pageIndex]) {
        debugPrint('  ${question.questionText}: ${question.answerAsString}');
      }
    }
    debugPrint("========================");
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_currentPageIndex > 0) {
      _goToPreviousPage();
      return false; // Don't exit the screen
    } else {
      // Show confirmation dialog for exiting survey
      return await _showExitConfirmation() ?? false;
    }
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Survey?'),
        content: const Text('Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
          itemCount: _surveyPages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return SurveyPage(
              pageTitle: _pageTitles[index],
              questions: _surveyPages[index],
              onContinue: _goToNextPage,
              onBack: index == 0 ? null : _goToPreviousPage,
              showContinueButton: _isCurrentPageValid(),
              currentPage: index,
              totalPages: _surveyPages.length,
              onAnswerChanged: _onAnswerChanged, // Pass the callback
            );
          },
        ),
      ),
    );
  }
}