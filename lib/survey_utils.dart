import 'package:flutter/material.dart';

class SurveyUtils {
  // App Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color subtitleColor = Colors.grey;

  // Spacing
  static const double defaultPadding = 24.0;
  static const double smallPadding = 16.0;
  static const double largePadding = 32.0;

  // Border Radius
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: subtitleColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle questionTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
    ),
    elevation: 2,
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[100],
    foregroundColor: textColor,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
    ),
    elevation: 0,
  );

  static ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      side: const BorderSide(color: primaryColor, width: 2),
    ),
    elevation: 2,
  );

  // Helper Functions
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(defaultPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Widget buildProgressBar(int currentPage, int totalPages) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: LinearProgressIndicator(
        value: (currentPage + 1) / totalPages,
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
        minHeight: 3,
      ),
    );
  }

  static Widget buildPageIndicator(int currentPage, int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? primaryColor : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  // Validation helpers
  static String getValidationMessage(bool hasSelection, bool hasMultiSelection) {
    if (hasMultiSelection) {
      return 'Please select at least one option to continue.';
    } else if (hasSelection) {
      return 'Please select an option to continue.';
    } else {
      return 'Please complete all questions to continue.';
    }
  }

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

// Extension for easier context access
extension BuildContextExtensions on BuildContext {
  void showSnackBar(String message, {Color? backgroundColor}) {
    SurveyUtils.showSnackBar(this, message, backgroundColor: backgroundColor);
  }

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}