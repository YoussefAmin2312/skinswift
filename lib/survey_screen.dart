import 'package:flutter/material.dart';
import 'package:skinswift/survey_page.dart';
import 'package:skinswift/survey_question.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<List<SurveyQuestion>> _surveyPages = [
    [
      SurveyQuestion(questionText: 'Acne', type: QuestionType.switchType),
      SurveyQuestion(questionText: 'Aging', type: QuestionType.switchType),
      SurveyQuestion(questionText: 'Dry Skin', type: QuestionType.switchType),
      SurveyQuestion(questionText: 'Under eye', type: QuestionType.switchType),
      SurveyQuestion(questionText: 'Sun protection', type: QuestionType.switchType),
    ],
    [
      SurveyQuestion(
        questionText: 'what is your age group?',
        type: QuestionType.multiSelectionType,
        options: ['<18', '18-29', '30-39', '40-49', '50-59', '60>'],
      ),
    ],
    [
      SurveyQuestion(
        questionText: 'How does your skin feel an hour or two after washing your face?',
        type: QuestionType.selectionType,
        options: [
          'Tight or dry',
          'Normal, comfortable, not oily or dry',
          'Oily or shiny, on forehead, nose',
          'Oily in some areas only',
        ],
      ),
    ],
    [
      SurveyQuestion(
        questionText: 'How often does your skin get shiny during the day?',
        type: QuestionType.selectionType,
        options: [
          'Rarely or never',
          'Occasionally, on forehead and nose',
          'Often, all over the face',
          'Never',
        ],
      ),
    ],
    [
      SurveyQuestion(
        questionText: 'After cleansing, do you need to apply moisturizer immediately?',
        type: QuestionType.selectionType,
        options: [
          'Yes',
          'Sometimes, mostly on cheeks',
          'Rarely, I feel comfortable without it',
          'No, skin feels oily',
        ],
      ),
    ],
    [
      SurveyQuestion(
        questionText: 'How does your skin behave during the cold or dry weather?',
        type: QuestionType.selectionType,
        options: [
          'Feels very dry, rough, flaky',
          'Some areas get dry, some oily',
          'No change or feels oily',
          'Feels balanced, no big changes',
        ],
      ),
    ],
    [
      SurveyQuestion(
        questionText: 'Do you experience visible pores?',
        type: QuestionType.selectionType,
        options: [
          'Not really',
          'Large pores in T-zone',
          'Large pores all over',
          'Medium pores, mostly invisible',
        ],
      ),
    ],
    // Add more lists of SurveyQuestion for additional pages
  ];

  bool _isCurrentPageValid() {
    for (var question in _surveyPages[_currentPageIndex]) {
      if (question.type == QuestionType.selectionType &&
          question.selectedOption == null) {
        return false;
      } else if (question.type == QuestionType.multiSelectionType &&
          question.selectedOptions.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _goToNextPage() {
    if (!_isCurrentPageValid()) {
      // Optionally show a message to the user that they need to select an option
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option to continue.'),
        ),
      );
      return;
    }
    if (_currentPageIndex < _surveyPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // This is the last page, handle survey completion
      print("Survey Completed!");
      for (var pageQuestions in _surveyPages) {
        for (var question in pageQuestions) {
          if (question.type == QuestionType.switchType) {
            print('${question.questionText}: ${question.value}');
          } else if (question.type == QuestionType.selectionType) {
            print('${question.questionText}: ${question.selectedOption}');
          } else if (question.type == QuestionType.multiSelectionType) {
            print('${question.questionText}: ${question.selectedOptions}');
          }
        }
      }
    }
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _surveyPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return SurveyPage(
                  pageTitle: index == 0 ? 'What can we help you with?' : null,
                  questions: _surveyPages[index],
                  onContinue: _goToNextPage,
                  onBack: index == 0 ? null : _goToPreviousPage,
                  showContinueButton: _isCurrentPageValid(),
                );
              },
            ),
          ),
          // Page indicators
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _surveyPages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPageIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 