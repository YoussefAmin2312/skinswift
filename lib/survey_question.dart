enum QuestionType {
  switchType,
  selectionType,
  multiSelectionType,
}

class SurveyQuestion {
  final String questionText;
  final QuestionType type;
  bool value;
  final List<String> options;
  String? selectedOption;
  final List<String> selectedOptions;

  SurveyQuestion({
    required this.questionText,
    this.type = QuestionType.switchType,
    this.value = false,
    this.options = const [],
    this.selectedOption,
    List<String>? selectedOptions,
  }) : selectedOptions = selectedOptions ?? <String>[];

  // Helper method to check if question is answered
  bool get isAnswered {
    switch (type) {
      case QuestionType.switchType:
        return true; // Switch always has a value
      case QuestionType.selectionType:
        return selectedOption != null;
      case QuestionType.multiSelectionType:
        return selectedOptions.isNotEmpty;
    }
  }

  // Get answer as string for logging/debugging
  String get answerAsString {
    switch (type) {
      case QuestionType.switchType:
        return value.toString();
      case QuestionType.selectionType:
        return selectedOption ?? 'No selection';
      case QuestionType.multiSelectionType:
        return selectedOptions.isEmpty ? 'No selections' : selectedOptions.join(', ');
    }
  }

  // Reset question to initial state
  void reset() {
    switch (type) {
      case QuestionType.switchType:
        value = false;
        break;
      case QuestionType.selectionType:
        selectedOption = null;
        break;
      case QuestionType.multiSelectionType:
        selectedOptions.clear();
        break;
    }
  }
}