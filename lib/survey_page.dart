import 'package:flutter/material.dart';
import 'survey_question.dart';

class SurveyPage extends StatefulWidget {
  final List<SurveyQuestion> questions;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final String? pageTitle;
  final bool showContinueButton;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onAnswerChanged; // Add this callback

  const SurveyPage({
    super.key,
    required this.questions,
    this.onContinue,
    this.onBack,
    this.pageTitle,
    this.showContinueButton = true,
    required this.currentPage,
    required this.totalPages,
    this.onAnswerChanged, // Add this parameter
  });

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _notifyAnswerChanged() {
    // Notify parent widget that an answer has changed
    if (widget.onAnswerChanged != null) {
      widget.onAnswerChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: widget.onBack,
          color: Colors.black87,
        )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${widget.currentPage + 1}/${widget.totalPages}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LinearProgressIndicator(
                  value: (widget.currentPage + 1) / widget.totalPages,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 3,
                ),
              ),

              const SizedBox(height: 32), // Increased spacing

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.pageTitle != null) ...[
                          Text(
                            widget.pageTitle!,
                            style: const TextStyle(
                              fontSize: 28, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40), // Increased spacing
                        ],

                        ...widget.questions.map((question) {
                          return _buildQuestionWidget(question);
                        }),

                        const SizedBox(height: 60), // Increased bottom spacing
                      ],
                    ),
                  ),
                ),
              ),

              // Continue Button
              Container(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.showContinueButton ? widget.onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.showContinueButton
                          ? const Color(0xFF6B73FF) // Using the app's primary color
                          : Colors.grey[300],
                      foregroundColor: widget.showContinueButton ? Colors.white : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 18), // Increased padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: widget.showContinueButton ? 2 : 0,
                    ),
                    child: Text(
                      widget.currentPage == widget.totalPages - 1 ? 'Complete Survey' : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(SurveyQuestion question) {
    if (question.type == QuestionType.switchType) {
      return _buildSwitchQuestion(question);
    } else if (question.type == QuestionType.selectionType) {
      return _buildSelectionQuestion(question);
    } else if (question.type == QuestionType.multiSelectionType) {
      return _buildMultiSelectionQuestion(question);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSwitchQuestion(SurveyQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Increased padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                question.questionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Switch.adaptive(
              value: question.value,
              onChanged: (bool value) {
                setState(() {
                  question.value = value;
                });
                _notifyAnswerChanged(); // Notify parent of change
              },
              activeColor: const Color(0xFF6B73FF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionQuestion(SurveyQuestion question) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          question.questionText,
          style: const TextStyle(
            fontSize: 22, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3, // Added line height for better readability
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32), // Increased spacing between question and options
        ...question.options.map((option) {
          final isSelected = question.selectedOption == option;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased vertical spacing
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    question.selectedOption = option;
                  });
                  _notifyAnswerChanged(); // Notify parent of change
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? const Color(0xFF6B73FF) : Colors.grey[50],
                  foregroundColor: isSelected ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF6B73FF) : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: isSelected ? 2 : 0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMultiSelectionQuestion(SurveyQuestion question) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          question.questionText,
          style: const TextStyle(
            fontSize: 22, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Select all that apply',
          style: TextStyle(
            fontSize: 15, // Slightly increased
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32), // Increased spacing
        ...question.options.map((option) {
          final isSelected = question.selectedOptions.contains(option);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isSelected) {
                      question.selectedOptions.remove(option);
                    } else {
                      question.selectedOptions.add(option);
                    }
                  });
                  _notifyAnswerChanged(); // Notify parent of change
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? const Color(0xFF6B73FF) : Colors.grey[50],
                  foregroundColor: isSelected ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF6B73FF) : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: isSelected ? 2 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        size: 22, // Slightly larger icon
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}