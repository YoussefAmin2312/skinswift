import 'package:skinswift/survey_question.dart';

class SurveyDataService {
  static List<List<SurveyQuestion>> getSurveyPages() {
    return [
      // Page 1: Skin Concerns
      [
        SurveyQuestion(questionText: 'Acne', type: QuestionType.switchType),
        SurveyQuestion(questionText: 'Aging', type: QuestionType.switchType),
        SurveyQuestion(questionText: 'Dry Skin', type: QuestionType.switchType),
        SurveyQuestion(questionText: 'Under eye', type: QuestionType.switchType),
        SurveyQuestion(questionText: 'Sun protection', type: QuestionType.switchType),
      ],

      // Page 2: Age Group
      [
        SurveyQuestion(
          questionText: 'What is your age group?',
          type: QuestionType.selectionType,
          options: ['<18', '18-29', '30-39', '40-49', '50-59', '60+'],
        ),
      ],

      // Page 3: Skin Feel After Washing
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

      // Page 4: Skin Shininess
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

      // Page 5: Moisturizer Need
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

      // Page 6: Cold Weather Behavior
      [
        SurveyQuestion(
          questionText: 'How does your skin behave during cold or dry weather?',
          type: QuestionType.selectionType,
          options: [
            'Feels very dry, rough, flaky',
            'Some areas get dry, some oily',
            'No change or feels oily',
            'Feels balanced, no big changes',
          ],
        ),
      ],

      // Page 7: Visible Pores
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

      // Page 8: Skin Surface Description
      [
        SurveyQuestion(
          questionText: 'How would you describe the surface of your skin?',
          type: QuestionType.selectionType,
          options: [
            'Smooth and even',
            'Some rough patches or small bumps',
            'Generally bumpy or textured',
          ],
        ),
      ],

      // Page 9: Skincare Product Reactions
      [
        SurveyQuestion(
          questionText: 'Do you ever react negatively to skincare products?',
          type: QuestionType.selectionType,
          options: [
            'Never',
            'Occasionally',
            'Often',
          ],
        ),
      ],

      // Page 10: Skin Tone
      [
        SurveyQuestion(
          questionText: 'Which best describes your skin tone? (This helps us tailor product and sun care advice)',
          type: QuestionType.selectionType,
          options: [
            'Very fair',
            'Fair',
            'Medium / Olive',
            'Brown',
            'Deep / Dark',
          ],
        ),
      ],

      // Page 11: Time Commitment
      [
        SurveyQuestion(
          questionText: 'How much time are you willing to spend in your routine?',
          type: QuestionType.selectionType,
          options: [
            'under 5 mins',
            '5-10 mins',
            '10-15 min',
            '20 mins',
          ],
        ),
      ],
    ];
  }

  static List<String?> getPageTitles() {
    return [
      'What can we help you with?',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];
  }

  static String analyzeSkinType(List<List<SurveyQuestion>> surveyData) {
    int dryScore = 0;
    int oilyScore = 0;
    int sensitiveScore = 0;

    // Analyze responses to determine skin type
    for (var page in surveyData) {
      for (var question in page) {
        if (question.selectedOption != null) {
          String answer = question.selectedOption!.toLowerCase();

          // Check for dry skin indicators
          if (answer.contains('tight') ||
              answer.contains('dry') ||
              answer.contains('flaky') ||
              answer.contains('yes') && question.questionText.contains('moisturizer')) {
            dryScore++;
          }

          // Check for oily skin indicators
          if (answer.contains('oily') ||
              answer.contains('shiny') ||
              answer.contains('large pores')) {
            oilyScore++;
          }

          // Check for sensitive skin indicators
          if (answer.contains('often') && question.questionText.contains('react negatively')) {
            sensitiveScore += 2;
          } else if (answer.contains('occasionally') && question.questionText.contains('react negatively')) {
            sensitiveScore++;
          }
        }
      }
    }

    // Determine skin type based on scores
    if (sensitiveScore >= 2) {
      return 'Sensitive';
    } else if (dryScore > oilyScore) {
      return 'Dry';
    } else if (oilyScore > dryScore) {
      return 'Oily';
    } else if (dryScore > 0 && oilyScore > 0) {
      return 'Combination';
    } else {
      return 'Normal';
    }
  }
}