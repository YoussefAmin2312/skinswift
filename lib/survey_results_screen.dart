import 'package:flutter/material.dart';
import 'survey_question.dart';
import 'survey_data_service.dart';
import 'home_screen.dart';
import 'package:skinswift/auth/login_or_register.dart';

class SurveyResultsScreen extends StatelessWidget {
  final List<List<SurveyQuestion>> surveyData;

  const SurveyResultsScreen({
    super.key,
    required this.surveyData,
  });

  @override
  Widget build(BuildContext context) {
    final skinType = SurveyDataService.analyzeSkinType(surveyData);
    final skinConcerns = _getSkinConcerns();
    final ageGroup = _getAgeGroup();
    final timeCommitment = _getTimeCommitment();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Skin Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Survey Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Skin Type Card
            _buildResultCard(
              title: 'Your Skin Type',
              content: skinType,
              icon: Icons.face,
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            // Skin Concerns Card
            if (skinConcerns.isNotEmpty)
              _buildResultCard(
                title: 'Your Skin Concerns',
                content: skinConcerns.join(', '),
                icon: Icons.healing,
                color: Colors.green,
              ),

            const SizedBox(height: 16),

            // Age Group Card
            if (ageGroup != null)
              _buildResultCard(
                title: 'Age Group',
                content: ageGroup,
                icon: Icons.calendar_today,
                color: Colors.orange,
              ),

            const SizedBox(height: 16),

            // Time Commitment Card
            if (timeCommitment != null)
              _buildResultCard(
                title: 'Daily Routine Time',
                content: timeCommitment,
                icon: Icons.schedule,
                color: Colors.purple,
              ),

            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginOrRegister(
                        skinType: skinType,
                        skinConcerns: skinConcerns,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B73FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Restart survey
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retake Survey',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getSkinConcerns() {
    final concerns = <String>[];
    final firstPage = surveyData.first;

    for (var question in firstPage) {
      if (question.type == QuestionType.multiSelectionType && question.selectedOptions.isNotEmpty) {
        concerns.addAll(question.selectedOptions);
      }
    }

    return concerns;
  }

  String? _getAgeGroup() {
    for (var page in surveyData) {
      for (var question in page) {
        if (question.questionText.toLowerCase().contains('age group')) {
          return question.selectedOption;
        }
      }
    }
    return null;
  }

  String? _getTimeCommitment() {
    for (var page in surveyData) {
      for (var question in page) {
        if (question.questionText.toLowerCase().contains('time are you willing')) {
          return question.selectedOption;
        }
      }
    }
    return null;
  }
}