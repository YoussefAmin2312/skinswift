import 'package:flutter/material.dart';
import 'package:skinswift/survey_question.dart';

class SurveyPage extends StatefulWidget {
  final List<SurveyQuestion> questions;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final String? pageTitle;
  final bool showContinueButton;

  const SurveyPage({
    super.key,
    required this.questions,
    this.onContinue,
    this.onBack,
    this.pageTitle,
    this.showContinueButton = true,
  });

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: widget.onBack,
                color: Colors.black,
              )
            : null,
        actions: const [
          // TODO: Add page indicators here
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.pageTitle != null)
                  Text(
                    widget.pageTitle!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 30),
                ...widget.questions.map((question) {
                  if (question.type == QuestionType.switchType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              question.questionText,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Switch(
                              value: question.value,
                              onChanged: (bool value) {
                                setState(() {
                                  question.value = value;
                                });
                              },
                              activeColor: Colors.white,
                              inactiveTrackColor: Colors.grey[400],
                              inactiveThumbColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (question.type == QuestionType.selectionType) {
                    return Column(
                      children: [SizedBox(height: 20,),
                        Text(question.questionText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        ...question.options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    question.selectedOption = option;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: question.selectedOption == option
                                      ? Colors.grey[600]
                                      : Colors.grey[300],
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: question.selectedOption == option
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  } else if (question.type == QuestionType.multiSelectionType) {
                    return Column(
                      children: [
                        SizedBox(height: 20,),
                        Text(question.questionText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        ...question.options.map((option) {
                          final isSelected = question.selectedOptions.contains(option);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.grey[600]
                                      : Colors.grey[300],
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }
                  return const SizedBox.shrink(); // Fallback for unsupported types
                }).toList(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.showContinueButton ? widget.onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'continue',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 