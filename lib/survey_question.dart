enum QuestionType {
  switchType,
  selectionType,
  multiSelectionType,
}

class SurveyQuestion {
  final String questionText;
  final QuestionType type;
  bool value;
  List<String> options;
  String? selectedOption;
  List<String> selectedOptions;

  SurveyQuestion({
    required this.questionText,
    this.type = QuestionType.switchType,
    this.value = false,
    this.options = const [],
    this.selectedOption,
    List<String>? selectedOptions,
  }) : selectedOptions = selectedOptions ?? [];
} 