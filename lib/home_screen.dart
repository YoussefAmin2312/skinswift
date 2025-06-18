import 'package:flutter/material.dart';
import 'survey_question.dart';
import 'ai_chat_screen.dart';
import 'routine_detail.dart';
import 'progress_tracking_screen.dart';
import 'product_investigation_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  final String skinType;
  final List<String> skinConcerns;
  final List<List<SurveyQuestion>> surveyData;

  const HomeScreen({
    super.key,
    required this.skinType,
    required this.skinConcerns,
    required this.surveyData,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentStreak = 0;
  bool morningRoutineCompleted = false;
  bool nightRoutineCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreen(
                  skinType: widget.skinType,
                  skinConcerns: widget.skinConcerns,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Card
            _buildStreakCard(),

            const SizedBox(height: 20),

            // Routines Section
            _buildRoutinesSection(),

            const SizedBox(height: 20),

            // Personal Assistant Card
            _buildPersonalAssistantCard(),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start Your Streak',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    currentStreak.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Consistency is Key',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Streak indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.blue : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutinesSection() {
    return Row(
      children: [
        Expanded(
          child: _buildRoutineCard(
            title: 'Morning Routine',
            completed: morningRoutineCompleted,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoutineDetailScreen(
                    routineType: 'Morning',
                    skinType: widget.skinType,
                    skinConcerns: widget.skinConcerns,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _buildRoutineCard(
            title: 'Night Routine',
            completed: nightRoutineCompleted,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoutineDetailScreen(
                    routineType: 'Night',
                    skinType: widget.skinType,
                    skinConcerns: widget.skinConcerns,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineCard({
    required String title,
    required bool completed,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: completed ? Colors.green : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: completed
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalAssistantCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Your personal assistant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AIChatScreen(
                    skinType: widget.skinType,
                    skinConcerns: widget.skinConcerns,
                  ),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Ask me !',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Investigate a product',
            icon: Icons.search,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductInvestigationScreen(
                    skinType: widget.skinType,
                    skinConcerns: widget.skinConcerns,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _buildActionButton(
            title: 'Track progress',
            icon: Icons.camera_alt,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressTrackingScreen(
                    skinType: widget.skinType,
                    skinConcerns: widget.skinConcerns,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoutineDialog(String routineType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$routineType Routine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Based on your ${widget.skinType.toLowerCase()} skin type, here\'s your recommended $routineType.toLowerCase() routine:'),
            const SizedBox(height: 12),
            ..._getRoutineSteps(routineType).map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(step)),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showAssistantDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personal Assistant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hi! I\'m here to help with your ${widget.skinType.toLowerCase()} skin care journey.'),
            const SizedBox(height: 12),
            if (widget.skinConcerns.isNotEmpty) ...[
              const Text('I see you\'re concerned about:'),
              const SizedBox(height: 8),
              ...widget.skinConcerns.map((concern) => Text('• $concern')),
            ],
            const SizedBox(height: 12),
            const Text('What would you like to know about your skincare routine?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Thanks!'),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature feature coming soon! We\'re working hard to bring you the best skincare experience.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  List<String> _getRoutineSteps(String routineType) {
    if (routineType == 'Morning') {
      switch (widget.skinType) {
        case 'Oily':
          return ['Gentle cleanser', 'Niacinamide serum', 'Light moisturizer', 'SPF 30+'];
        case 'Dry':
          return ['Hydrating cleanser', 'Hyaluronic acid serum', 'Rich moisturizer', 'SPF 30+'];
        case 'Sensitive':
          return ['Gentle cleanser', 'Fragrance-free moisturizer', 'SPF 30+ (mineral)'];
        case 'Combination':
          return ['Balanced cleanser', 'Light serum', 'Gel moisturizer', 'SPF 30+'];
        default:
          return ['Gentle cleanser', 'Moisturizer', 'SPF 30+'];
      }
    } else {
      switch (widget.skinType) {
        case 'Oily':
          return ['Oil cleanser', 'Gentle cleanser', 'BHA treatment', 'Night moisturizer'];
        case 'Dry':
          return ['Oil cleanser', 'Hydrating cleanser', 'Rich serum', 'Night cream'];
        case 'Sensitive':
          return ['Gentle cleanser', 'Soothing serum', 'Rich moisturizer'];
        case 'Combination':
          return ['Oil cleanser', 'Balanced cleanser', 'Targeted treatments', 'Night moisturizer'];
        default:
          return ['Cleanser', 'Treatment', 'Night moisturizer'];
      }
    }
  }


}